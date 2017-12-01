### Aurora RDS Configuration

########################
## Cluster
########################

resource "aws_rds_cluster" "aurora_cluster" {

    cluster_identifier            = "${var.environment_name}_aurora_cluster"
    database_name                 = "${var.rds_database_name}"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 14
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
    final_snapshot_identifier     = "${var.environment_name}_aurora_cluster"
    vpc_security_group_ids        = [
        "${var.vpc_rds_security_group_ids}"
    ]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Cluster"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }
resource "aws_route53_zone" "external" {
  count   = "${var.external_dns_enable}"
  name    = "${var.external_domain_name}"
  comment = "External Domain"
}

resource "aws_route53_zone" "internal" {
  name   = "${var.internal_domain_name}"
  comment = "Internal Domain"
  vpc_id = "${var.vpc_id}"
}

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {

    count                 = "${length(split(",", var.vpc_rds_subnet_ids))}"

    identifier            = "${var.environment_name}_aurora_instance_${count.index}"
    cluster_identifier    = "${aws_rds_cluster.aurora_cluster.id}"
    instance_class        = "db.t2.small"
    db_subnet_group_name  = "${aws_db_subnet_group.aurora_subnet_group.name}"
    publicly_accessible   = true
    availability_zones = ["us-west-2a", "us-west-2b", "us-east-1a"]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Instance-${count.index}"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}


resource "aws_db_subnet_group" "aurora_subnet_group" {

    name          = "${var.environment_name}_aurora_db_subnet_group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = [
        "${split(",", var.vpc_rds_subnet_ids)}"
    ]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Subnet-Group"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

}