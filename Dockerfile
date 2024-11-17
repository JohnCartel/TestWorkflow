# 使用 Windows Server Core LTSC 2019 作为基础镜像
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# 安装 Git、Node.js、npm、Yarn、Python、7-Zip 和 MSBuild
RUN powershell -Command "$ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.39.1.windows.1/MinGit-2.39.1-64-bit.zip -OutFile git.zip; \
    Expand-Archive -Path git.zip -DestinationPath C:\git; \
    Remove-Item -Force git.zip; \
    setx /M PATH '$Env:PATH;C:\git\cmd'; \
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine'); \
    Invoke-WebRequest -Uri https://nodejs.org/dist/v16.16.0/node-v16.16.0-x64.msi -OutFile nodejs.msi; \
    Start-Process msiexec.exe -ArgumentList '/i', 'nodejs.msi', '/quiet', '/norestart' -NoNewWindow -Wait; \
    Remove-Item -Force nodejs.msi; \
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine'); \
    npm install -g npm@8.11.0; \
    npm install -g yarn; \
    Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.10.4/python-3.10.4-amd64.exe -OutFile python.exe; \
    Start-Process python.exe -ArgumentList '/quiet', 'InstallAllUsers=1', 'PrependPath=1' -NoNewWindow -Wait; \
    Remove-Item -Force python.exe; \
    Invoke-WebRequest -Uri https://www.7-zip.org/a/7z2107-x64.msi -OutFile 7zip.msi; \
    Start-Process msiexec.exe -ArgumentList '/i', '7zip.msi', '/quiet', '/norestart' -NoNewWindow -Wait; \
    Remove-Item -Force 7zip.msi; \
    Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vs_buildtools.exe -OutFile vs_buildtools.exe; \
    Start-Process vs_buildtools.exe -ArgumentList '--quiet', '--wait', '--norestart', '--nocache', '--installPath', 'C:\BuildTools', '--add', 'Microsoft.VisualStudio.Workload.MSBuildTools', '--add', 'Microsoft.VisualStudio.Workload.VCTools' -NoNewWindow -Wait; \
    Remove-Item -Force vs_buildtools.exe; \
    npm config set msvs_version 2019; \
    npm config set python python3.10; \
    Remove-Item -Recurse -Force C:\ProgramData\Microsoft\VisualStudio\Packages; \
    Remove-Item -Recurse -Force C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances; \
    Remove-Item -Recurse -Force C:\ProgramData\Microsoft\VisualStudio\Packages\_bootstrapper; \
    Remove-Item -Recurse -Force C:\ProgramData\Microsoft\VisualStudio\Packages\_bootstrapper\_bootstrapper;"

# 设置工作目录
WORKDIR /workspace

# 复制当前目录内容到工作目录
COPY . /workspace

# 设置默认命令
CMD ["powershell"]