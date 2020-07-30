#include <iostream>
#include <thread>
#include <chrono>

int main() {
    std::cout << "cpp-cicd-devops-jenkins-v3" << std::endl;
    for (int i = 0; i < 60; ++i) {
        std::cout << "will sleep for 1s" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    return 0;
}