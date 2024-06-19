{ inputs }:

{
  name = "my-test";
  nodes.machine = { ... }: { };

  testScript = ''
    start_all()

    machine.succeed("sleep 10")
  '';
}
