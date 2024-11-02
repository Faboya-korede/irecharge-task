output "lb_sg" {
  value = aws_security_group.lb.id
}

output "task-sg" {
  value = aws_security_group.task-sg.id
}