module "vpc" {
    # "terraform-aws-modules/vpc/aws"モジュールを使用
    source = "terraform-aws-modules/vpc/aws"

    name = local.name
    cidr = "10.0.0.0/16"

    azs             = ["${local.region}a", "${local.region}c"]
    public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

    public_subnet_names  = ["Public Subnet 1a", "Public Subnet 1c"]
    private_subnet_names = ["Private Subnet 1a", "Private Subnet 1c"]

    enable_dns_hostnames = true # DNS サーバーによる名前解決が有効
    enable_dns_support   = true # パブリック DNS ホスト名を自動的に割り当て

    enable_nat_gateway = true
}