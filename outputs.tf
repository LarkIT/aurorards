output "aurora_cluster_id" {
  value = "${aws_rds_cluster.aurora_cluster.id}"
}

output "aurora_cluster_instance" {
  value = "${aws_rds_cluster_instance.aurora_cluster_instance_id}"
}

