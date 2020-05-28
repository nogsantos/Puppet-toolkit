# Caso o Puppet Master não encontre nenhuma declaração de node explícita para um agente, em última
# instância pode-se criar um node simplesmente chamado default, que casará apenas para os agentes
# que não encontraram uma definição de node.
node default {
  package { 'vim':
    ensure => present
  }
}
