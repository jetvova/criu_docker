#include <iostream>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/udp.h>
#include <arpa/inet.h>
#include <cstring>

#define UDP_REPAIR_QUEUE 105

// CLIENT COMMAND: g++ udpClient.cpp -o udpClient.out && ./udpClient.out
// SERVER COMMAND: socat - UDP4-LISTEN:3000 &

int main() {
    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        std::cerr << "Error creating socket" << std::endl;
        return -1;
    }

    // Enable cork option
    int cork = 1;
    if (setsockopt(sock, IPPROTO_UDP, UDP_CORK, &cork, sizeof(cork)) < 0) {
        std::cerr << "Error setting cork option" << std::endl;
        close(sock);
        return -1;
    }

    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(3000);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    struct sockaddr_in server_addr2;
    memset(&server_addr2, 0, sizeof(server_addr2));
    server_addr2.sin_family = AF_INET;
    server_addr2.sin_port = htons(3001);
    server_addr2.sin_addr.s_addr = inet_addr("127.0.0.1");

    std::string message3000 = "3000 1\n";
    if (sendto(sock, message3000.c_str(), message3000.length(), 0, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        std::cerr << "Error sending message" << std::endl;
        close(sock);
        return -1;
    }

    std::string message3001 = "3001 1\n";
    if (sendto(sock, message3001.c_str(), message3001.length(), 0, (struct sockaddr*)&server_addr2, sizeof(server_addr2)) < 0) {
        std::cerr << "Error sending message" << std::endl;
        close(sock);
        return -1;
    }
    
    // Enable UDP_REPAIR_QUEUE option
    int udpQueueRepair = 1;
    if (setsockopt(sock, IPPROTO_UDP, UDP_REPAIR_QUEUE, &udpQueueRepair, sizeof(udpQueueRepair)) < 0) {
        std::cerr << "Error setting UDP_QUEUE_REPAIR" << std::endl;
        close(sock);
        return -1;
    }

    // Reading from buffer
    char queue[1024] = {0};
    int recv_len = recv(sock, queue, sizeof(queue) - 1, 0);
    if (recv_len < 0) {
        std::cerr << "Error receiving response: " << recv_len << std::endl;
        close(sock);
        return -1;
    }
    
    queue[recv_len] = '\0';
    std::cout << "Current Queue State, len: " << recv_len << std::endl;
    for (int i = 0; i<recv_len; i++) {
        std::cout << queue[i];
    }
    std::cout << std::endl;

    udpQueueRepair = 0;
    if (setsockopt(sock, IPPROTO_UDP, UDP_REPAIR_QUEUE, &udpQueueRepair, sizeof(udpQueueRepair)) < 0) {
        std::cerr << "Error setting UDP_QUEUE_REPAIR" << std::endl;
        close(sock);
        return -1;
    }

    std::cout << "Dump here" << std::endl;
    sleep(3);
    std::cout << "Restored here" << std::endl;

    message3000 = "3000 2\n";
    if (sendto(sock, message3000.c_str(), message3000.length(), 0, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        std::cerr << "Error sending message" << std::endl;
        close(sock);
        return -1;
    }

    sleep(1);

    message3000 = "3000 3\n";
    if (sendto(sock, message3000.c_str(), message3000.length(), 0, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        std::cerr << "Error sending message" << std::endl;
        close(sock);
        return -1;
    }
    
    cork = 0;
    if (setsockopt(sock, IPPROTO_UDP, UDP_CORK, &cork, sizeof(cork)) < 0) {
        std::cerr << "Error setting cork option" << std::endl;
        close(sock);
        return -1;
    }

    return 0;
}
