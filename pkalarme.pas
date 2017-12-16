{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit pkAlarme;

interface

uses
  alarme, frmalarm, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('alarme', @alarme.Register);
end;

initialization
  RegisterPackage('pkAlarme', @Register);
end.
