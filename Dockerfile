# 使用 Windows Server Core LTSC 2019 作为基础镜像
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# 安装 Git
RUN powershell -Command "$ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.39.1.windows.1/MinGit-2.39.1-64-bit.zip -OutFile git.zip; \
    Expand-Archive -Path git.zip -DestinationPath C:\git; \
    Remove-Item -Force git.zip; \
    setx /M PATH '$Env:PATH;C:\git\cmd' && \
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')"

# 安装 Node.js 16.16.0
RUN powershell -Command "$ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://nodejs.org/dist/v16.16.0/node-v16.16.0-x64.msi -OutFile nodejs.msi; \
    Start-Process msiexec.exe -ArgumentList '/i', 'nodejs.msi', '/quiet', '/norestart' -NoNewWindow -Wait; \
    Remove-Item -Force nodejs.msi"

# 更新 npm 并安装 Yarn
RUN powershell -Command "$ErrorActionPreference = 'Stop'; \
    npm install -g npm@latest && \
    npm install -g yarn"

# 安装 Python
RUN powershell -Command "$ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.10.4/python-3.10.4-amd64.exe -OutFile python.exe; \
    Start-Process python.exe -ArgumentList '/quiet', 'InstallAllUsers=1', 'PrependPath=1' -NoNewWindow -Wait; \
    Remove-Item -Force python.exe"

# 安装 7-Zip
RUN powershell -Command "$ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://www.7-zip.org/a/7z2107-x64.msi -OutFile 7zip.msi; \
    Start-Process msiexec.exe -ArgumentList '/i', '7zip.msi', '/quiet', '/norestart' -NoNewWindow -Wait; \
    Remove-Item -Force 7zip.msi"

# 设置工作目录
WORKDIR /workspace

# 复制当前目录内容到工作目录
COPY . /workspace

# 设置默认命令
CMD ["powershell"]