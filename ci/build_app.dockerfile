FROM cpp-cicd-devops-jenkins as build
WORKDIR /app
COPY . /app
RUN rm -rf build && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build .
CMD ["./build/main"]