### Aurora RDS Configuration

########################
## Cluster
########################

resource "aws_rds_cluster" "aurora-cluster" {

    cluster_identifier            = "${var.environment_name}-aurora-cluster"
    database_name                 = "${var.rds_database_name}"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 14
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    availability_zones            = ["us-west-2a", "us-west-2b", "us-west-2c"]
    db_subnet_group_name          = "${aws_db_subnet_group.aurora-subnet-group.name}"
    final_snapshot_identifier     = "${var.environment_name}-aurora-cluster"
    vpc_security_group_ids        = [ "${var.vpc_rds_security_group_ids}" ]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Cluster"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        prevent_destroy = true
    }
}

#resource "aws_route53_zone" "external" {
 # count   = "${var.external_dns_enable}"
 # name    = "${var.external_domain_name}"
 # comment = "External Domain"
#}

#resource "aws_route53_zone" "internal" {
  #name   = "${var.internal_domain_name}"
  #comment = "Internal Domain"
  #vpc_id = "${var.vpc_id}"

    #lifecycle {
        #create_before_destroy = true
    #}

#}

resource "aws_rds_cluster_instance" "aurora-cluster-instance" {

    count                 = "${length(split(",", var.vpc_rds_subnet_ids))}"

    identifier            = "${var.environment_name}-aurora-instance-${count.index}"
    cluster_identifier    = "${aws_rds_cluster.aurora-cluster.id}"
    instance_class        = "db.t2.small"
    db_subnet_group_name  = "${aws_db_subnet_group.aurora-subnet-group.name}"
    publicly_accessible   = true

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Instance-${count.index}"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        prevent_destroy = true
    }

}


resource "aws_db_subnet_group" "aurora-subnet-group" {

    name          = "${var.environment_name}-aurora-db-subnet-group"
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
