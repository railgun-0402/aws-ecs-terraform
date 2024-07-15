locals {
  name   = replace(basename(path.cwd), "_", "-") # カレントディレクトリの名前
  region = "ap-northeast-1"
  app    = "go-simple-server"
}