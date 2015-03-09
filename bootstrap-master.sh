#!/bin/sh

# Run on VM to bootstrap Puppet Master server

if ps aux | grep "puppet master" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    echo "[SZAYAT] getting puppet master..."
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    sudo dpkg -i puppetlabs-release-trusty.deb && \
    sudo apt-get update -yq && sudo apt-get upgrade -yq && \
    sudo apt-get install -yq puppetmaster

    # Configure /etc/hosts file
    echo "[SZAYAT] configuring /etc/hosts..."
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   agent.01.example.com  agent01" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.20   agent.02.example.com  agent02" | sudo tee --append /etc/hosts 2> /dev/null

    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    echo "[SZAYAT] alternate DNS names to puppet.conf"
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppet.example.com/' /etc/puppet/puppet.conf

    # Install some initial puppet modules on Puppet Master server
    echo "[SZAYAT] installing puppetlabs-ntp..."
    sudo puppet module install puppetlabs-ntp
    echo "[SZAYAT] installing garethr-docker..."   
    sudo puppet module install garethr-docker
    echo "[SZAYAT] installing puppetlabs-git..."   
    sudo puppet module install puppetlabs-git
    echo "[SZAYAT] installing puppetlabs-vcsrepo..."   
    sudo puppet module install puppetlabs-vcsrepo
    #echo "[SZAYAT] installing garystafford-fig..."   
    #sudo puppet module install garystafford-fig

    # symlink manifest from Vagrant synced folder location
    ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp
fi
