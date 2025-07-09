resource "aws_security_group" "cluster_master_sg" {
    name        = format("%s-master-sg", var.cluster_name)
    description = "Security group for EKS cluster control plane"
    vpc_id      = var.cluster_vpc

    egress {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, {
        Name = format("%s-master-sg", var.cluster_name)
    })
}

resource "aws_security_group_rule" "cluster_ingress_https" {
    description       = "HTTPS ingress for Kubernetes API"
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.cluster_master_sg.id
}

# Regra para comunicação entre cluster e nodes
resource "aws_security_group_rule" "cluster_ingress_node_https" {
    description              = "Allow nodes to communicate with the cluster API Server"
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.cluster_master_sg.id
    security_group_id        = aws_security_group.cluster_master_sg.id
}
