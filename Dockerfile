FROM ghcr.io/flux-iac/tf-runner:v0.16.0-rc.5

ENV TF_VERSION=1.5.7
ENV TARGETARCH=amd64

# Switch to root to have permissions for operations
USER root

# Install the specified Terraform
ADD https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${TARGETARCH}.zip /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip
RUN unzip -q /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip -d /usr/local/bin/ -o && \
    rm /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip && \
    chmod +x /usr/local/bin/terraform

RUN echo https://downloads.1password.com/linux/alpinelinux/stable/ >> /etc/apk/repositories && \
    wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys && \
    apk update && apk add 1password-cli

# Get the op cli version to check installation
RUN op --version

# Switch back to the non-root user after operations
USER 65532:65532