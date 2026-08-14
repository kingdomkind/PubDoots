Heyo, these are the configuration files for my machines.

The entry point is `reload.sh`.\
Per host configuration can be found in `unique/hostname`.\
Shared configuration can be found in `modules/`.

`main.lua` finds the matching hostname in `unique/`, and executes `system.lua`, which is then in control. It will eventually retun a table, representing the configuration.\
Each host / module returns a table, which is then merged into the calling function, eventually leading to an entirely merged table, which is then returned by `system.lua`

This configuration uses lux, and features my lua framework, primarily found in `lib.lua`.
My configuration specific patches to this framework can be found in `patch.lua`.

My config uses the following generators: [desym](https://github.com/Mayware/desym), [depac](https://github.com/Mayware/depac).

The doots are licensed under `Apache-2.0`, where applicable. Exemptions will be mentioned in the files relevant.
