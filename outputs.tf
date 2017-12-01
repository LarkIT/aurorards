output "aurora_cluster_id" {
  value = "${stage_aurora_cluster.id}"
}

output "aurora_cluster_instance" {
  value = "${stage_aurora_cluster.id}"
}
output "cluster_address" {
    value = "${aws_rds_cluster.aurora_cluster.address}"
}
