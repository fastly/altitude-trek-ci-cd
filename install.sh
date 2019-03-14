openssl aes-256-cbc -K $encrypted_986893cb6ef7_key -iv $encrypted_986893cb6ef7_iv -in secrets.tar.enc -out secrets.tar -d
tar xvf secrets.tar
curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip;
shasum -a 256 /tmp/terraform.zip | grep 5925cd4d81e7d8f42a0054df2aafd66e2ab7408dbed2bd748f0022cfe592f8d2 || travis_terminate 1;
unzip /tmp/terraform.zip -d /tmp
mkdir -p ~/bin
mv /tmp/terraform ~/bin
export PATH="~/bin:$PATH"
