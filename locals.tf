# locals.tf
locals {
    project_roles = toset([
        "roles/logging.logWriter",
        "roles/logging.bucketWriter",
        "roles/storage.objectCreator",
        "roles/storage.admin"
    ])
}