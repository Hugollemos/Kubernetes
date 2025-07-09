resource "aws_eks_cluster" "eks_cluster" {
    name     = var.cluster_name
    version  = var.k8s_version
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        security_group_ids = [
            aws_security_group.cluster_master_sg.id
        ]

        subnet_ids = var.private_subnets
        
        endpoint_config_private_access = true
        endpoint_config_public_access  = true
        endpoint_config_public_access_cidrs = ["0.0.0.0/0"]
    }

    # Enable logging
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

    tags = merge(var.tags, {
        Name = "${var.cluster_name}-cluster"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    })

    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_policy,
        aws_iam_role_policy_attachment.eks_service_policy,
    ]
}
