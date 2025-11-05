FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

COPY docker-setup.sh .
RUN chmod +x docker-setup.sh
RUN ./docker-setup.sh

EXPOSE 8080

CMD ["python", "skill_seeker_mcp/server.py"]