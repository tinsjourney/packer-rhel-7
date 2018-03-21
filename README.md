# Packer Example - Red Hat Enterprise Linux 7 Vagrant Box using Ansible provisioner

This example build configuration installs and configures RHEL 7 x86_64 using Ansible, and then generates two Vagrant box files, for:

  - VirtualBox
  - VMware

The example can be modified to use more Ansible roles, plays, and included playbooks to fully configure (or partially) configure a box file suitable for deployment for development environments.

## Paternity

This repo is a shamelessly fork from [Jeff Geerling](https://github.com/geerlingguy/packer-centos-7), modified to create a Red Hat Enterprise Linux Vagrant Box.
So all gratitude should go to him, and all criticism to myself.

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)
  - [VMware Fusion](http://www.vmware.com/products/fusion/) (or Workstation - if you want to build the VMware box)
  - [Ansible](http://docs.ansible.com/intro_installation.html)

You must have a Red Hat Subscription to download the Red Hat Enterprise Linux 7 iso. If you don't, [create an account](https://developers.redhat.com) and accept the terms and conditions of the Red Hat Developer Program, which provides no-cost subscriptions for development use only.

## Usage

  - Make sure all the required software (listed above) is installed.
  - cd to the directory containing this README.md file,
  - Create `iso/` directory and move inside your Red Hat Enterprise Linux iso.
  - Edit rhel7.json file, check if `iso_urls` and `iso_checksum` match your RHEL iso.
  - Create file secret.json, with your RHSM informations (where ansible_repos, is the repository where you can find ansible core),
```
    {
      "rhsm_username": "XXXXXXXX",
      "rhsm_password" : "XXXXXXXX",
      "rhsm_pool" : "XXXXXXXX",
      "ansible_repos" : "XXXXXXXX-rpms"
    }
```
- Finally run:
```
    $ packer build --var-file=secret.json rhel7.json
```
After a few minutes, Packer should tell you the box was generated successfully.

If you want to only build a box for one of the supported virtualization platforms (e.g. only build the VMware box), add `--only=vmware-iso` to the `packer build` command:
```
    $ packer build --only=vmware-iso --var-file=secret.json rhel7.json

    $ packer build --only=virtualbox-iso --var-file=secret.json rhel7.json
```
## Testing built boxes

###  Prerequisite

The following vagrant plugins should be installed:

 - [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
 - [vagrant-registration](https://github.com/projectatomic/adb-vagrant-registration)

During the build of the RHEL7 box, a 'yum update' is launched. The VirtualBox Guest Additions installed are probably not the one for the newly installed kernel. So when the VM will start using this box, it will need to re-compile de VirtualBox Guest Additions. This is done using the vagrant plugins vagrant-vbguest.d

Also we want to register the VM to RHSM, so we do that with vagrant-registration plugin.

File .vagrantplugins make sure those vagrant plugins are installed.

### Let's roll !!!

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From this same directory, run one of the following commands after building the boxes:
```
    # For VMware Fusion:
    $ eval $(./jsonenv < secret.json) vagrant up vmware --provider=vmware_fusion

    # For VirtualBox:
    $ eval $(./jsonenv < secret.json) vagrant up virtualbox --provider=virtualbox
```
[jsonenv](jsonenv) is a small python script stolen from [Keith Rarick](https://gist.github.com/kr/6161118) which convert a json dictionary into environment variables.

## TODO
  - Add registration to Satellite.

## License

MIT license.

## Author Information

Created in 2014 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).
Modified in 2017 by [Tinsjourney](https://www.gnali.org/)
