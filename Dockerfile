# 基于第一个镜像
FROM your-dockerhub-username/base-image:latest

# 安装 Git、Node.js 16.x、npm、Yarn、Python、7-Zip 和 Visual Studio Build Tools (仅 MSBuildTools 和 VCTools)
RUN choco install -y git \
    nodejs --version=16.16.0 \
    yarn \
    python \
    7zip \
    visualstudio2019buildtools --package-parameters '--add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.VCTools'

# 设置环境变量
RUN setx /M PATH "%PATH%;C:\Program Files\Git\cmd;C:\Program Files\nodejs;C:\Python39;C:\Program Files\7-Zip"

# 清理 Chocolatey 缓存
RUN powershell -Command "Remove-Item -Recurse -Force C:\ProgramData\chocolatey\lib\*; \
    Remove-Item -Recurse -Force C:\ProgramData\chocolatey\bin\*; \
    Remove-Item -Recurse -Force C:\ProgramData\chocolatey\choco.exe.old"

# 设置工作目录
WORKDIR /workspace

# 复制当前目录内容到工作目录
COPY . /workspace

# 设置默认命令
CMD ["powershell"]