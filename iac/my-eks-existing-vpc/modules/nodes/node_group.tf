resource "aws_eks_node_group" "cluster" {
    cluster_name    = var.eks_cluster.name
    node_group_name = var.node_group_name
    node_role_arn   = aws_iam_role.eks_nodes_roles.arn
    subnet_ids      = var.private_subnets
    
    instance_types = var.nodes_instances_sizes
    capacity_type  = "ON_DEMAND"
    
    # AMI será selecionada automaticamente baseada na versão do cluster
    ami_type = "AL2_x86_64"
    
    scaling_config {
        desired_size = var.auto_scale_options.desired
        max_size     = var.auto_scale_options.max
        min_size     = var.auto_scale_options.min
    }
    
    update_config {
        max_unavailable = 1
    }
    
    # Configure remote access (optional)
    # remote_access {
    #   ec2_ssh_key = var.ec2_ssh_key
    #   source_security_group_ids = [var.additional_security_group_ids]
    # }
    
    tags = merge(var.tags, {
        Name = "${var.cluster_name}-${var.node_group_name}"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    })

    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_node_policy,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_role_policy_attachment.eks_container_registry_policy,
    ]

    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    lifecycle {
        ignore_changes = [scaling_config[0].desired_size]
    }
}
