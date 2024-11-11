# 1. Ubuntu 베이스 이미지 선택
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 2. 기본 패키지 업데이트 및 Python 및 필수 도구 설치
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \ 
    curl \
    vim \
    git \
    build-essential \   
    libssl-dev \        
    libc6-dev \
    python3-dev \
    cmake \
    pkg-config \
    && rm -rf /var/lib/apt/lists/* 

# 3. 작업 디렉토리 설정
WORKDIR /app

# 4. 파일 복사
COPY . /app

# 5. Python 가상환경 생성
RUN python3 -m venv venv

# 6. pip 업그레이드 및 wheel 설치
RUN /app/venv/bin/pip install --upgrade pip setuptools wheel

# 7. grpcio 먼저 설치 (pre-built wheel 사용)
RUN /app/venv/bin/pip install --no-cache-dir grpcio==1.48.2 --ignore-installed

# 8. gdown 설치
RUN /app/venv/bin/pip install gdown

# 9. requirements.txt에서 grpcio 제외하고 나머지 패키지 설치
RUN grep -v "grpcio" requirements.txt > requirements_new.txt && \
    /app/venv/bin/pip install --no-cache-dir -r requirements_new.txt

# # 10. 데이터셋 다운로드
# RUN /app/venv/bin/gdown --folder "https://drive.google.com/drive/u/2/folders/1JS-RjdRVXvTLsDJdF1NKNLQXD506tNLj"

# 11. 환경 변수 설정
ENV PATH="/app/venv/bin:$PATH"

# 12. 기본 실행 명령
CMD ["tail", "-f", "/dev/null"]
