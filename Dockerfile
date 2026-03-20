FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    liblua5.1-dev \
    lua5.1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# /pz/game  — mount your PZ game folder here (read-only)
# /output   — mount your output destination here (read-write)
VOLUME ["/pz/game", "/output"]

ENTRYPOINT ["/docker-entrypoint.sh"]
