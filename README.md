# Upman

UPdata MANager is used in conjunction with [Upclid](https://github.com/flat235/upclid) to display pending updates and reboots.

## Working features
 - displaying pending updates
 - displaying pending reboots
 - displaying locked packages
 - authenticating users via ldap (for actions, displaying works without login)
 - authorizing users via ldap (simple group check)
 - showing custom facts about systems (if custom facts are implemented)
 - triggering updates runs
 - triggering reboots

## Currently plannend features
 - (un)locking packages
 - authenticating client systems via tokens
 
## Trying out Upman
  - Install current erlang (i.e. from [here](https://www.erlang-solutions.com/resources/download.html)
  - Install dependencies with `mix deps.get`
  - configure ldap connection in `config/config.exs`
  - Start Phoenix endpoint with `mix phx.server`
  - install and start [Upclid](https://github.com/flat235/upclid) on one or more systems

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributions very welcome!
Issues, pull requests, documentation, questions, feature request, whatever your method - your contributions are very welcome!

## License
[Apache 2.0](LICENSE)
