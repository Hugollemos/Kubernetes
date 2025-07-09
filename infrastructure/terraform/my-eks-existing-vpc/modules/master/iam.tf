data "aws_iam_policy_document" "eks_cluster_role" {
    version = "2012-10-17"

    statement {
        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type        = "Service"
            identifiers = ["eks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "eks_cluster_role" {
    name               = format("%s-eks-cluster-role", var.cluster_name)
    assume_role_policy = data.aws_iam_policy_document.eks_cluster_role.json

    tags = merge(var.tags, {
        Name = "${var.cluster_name}-cluster-role"
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster_role.name
}

# Nota: AmazonEKSServicePolicy foi deprecated para novos clusters EKS 1.13+
# Mantendo para compatibilidade com versões mais antigas
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.eks_cluster_role.name
}
