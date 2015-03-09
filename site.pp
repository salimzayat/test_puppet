node default {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git
}

node 'agent.01.example.com', 'agent.02.example.com' {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, docker
}