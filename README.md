# Upman

UPdata MANager is used in conjunction with [Upclid](https://github.com/flat235/upclid) to display pending updates and reboots.

## Working features
 - displaying pending updates
 - displaying pending reboots
 - displaying locked packages
 - display log of last update-run
 - authenticating users via ldap (for actions, displaying works without login)
 - authorizing users via ldap (simple group check)
 - showing custom facts about systems (if custom facts are implemented)
 - triggering updates runs
 - triggering reboots
 - panic button (abort all updates/reboot, that have not been started)

## Currently plannend features
 - (un)locking packages
 - instead of authenticating clients: update-clearance includes list of reported updatetable packages. client only installs updates, if list matches.
 
## Deploying Upman
  - Install current erlang (i.e. from [here](https://www.erlang-solutions.com/resources/download.html)
  - copy `upman.service` to `/etc/systemd/system/upman.service`
  - copy `upman.toml` to `/etc/upman.toml` and customize the ldap settings, port, etc.
  - run `mix deps.get` to install dependencies
  - run `mix phx.digest` to create compressed assets
  - run `MIX_ENV=prod mix release` to create a release-package
  - run `tar -C /opt/upman -xzf _build/prod/upman-$version.tar.gz` to install the release locally
  - Start Upman via `systemctl start upman`
  - install and start [Upclid](https://github.com/flat235/upclid) on one or more systems

Now you can visit [`localhost`](http://localhost) from your browser.

## Contributions very welcome!
Issues, pull requests, documentation, questions, feature request, whatever your method - your contributions are very welcome!

## License
[Apache 2.0](LICENSE)
