FROM python:3.9-slim

WORKDIR /app

# �ˑ��֌W���C���X�g�[��
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# �A�v���P�[�V�����t�@�C�����R�s�[
COPY app.py .

# Streamlit�̐ݒ�
RUN mkdir -p /root/.streamlit
RUN echo '[server]\nheadless = true\nport = 8501\naddress = "0.0.0.0"\n' > /root/.streamlit/config.toml

EXPOSE 8501

CMD ["streamlit", "run", "app.py"]