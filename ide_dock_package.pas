{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ide_dock_package;

{$warn 5023 off : no warning about unused units}
interface

uses
  uDockPackage, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('uDockPackage', @uDockPackage.Register);
end;

initialization
  RegisterPackage('ide_dock_package', @Register);
end.
