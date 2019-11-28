unit uDockPackage;

{$mode objfpc}{$H+}

{ With AnchorDocking it is possible to make the IDE a single window. However
  if you open a package you first have to dock it because otherwise it will
  be a floating window. When you close the IDE the next time you open it you
  will have to do this again. With this IDE extension every new package editor
  is automatically docked in the same tab with the project inspector.

  Copyright (C) 2019 by Johannes Rosleff Sörensen

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
  Boston, MA 02110-1335, USA.
}


interface

uses
  Classes, SysUtils, Forms, IDEWindowIntf, Controls;

type

  { TDockPackageWindow }

  // Use an object as a helper because the handler in register expects a
  // procedure of object
  TDockPackageWindow = object
    procedure OnFormAdded(Sender: TObject; Form: TCustomForm);
    procedure DoFormDock(Sender: TObject);
  end;

var
  DockPackageWindow: TDockPackageWindow;

procedure Register;

implementation

procedure Register;
begin
  Screen.AddHandlerFormAdded( @DockPackageWindow.OnFormAdded ); // See OnFormAdded
end;

{ TDockPackageWindow }

// OnFormAdded is called whenever a Form is created. We have to filter out the
// Package Editors here. This is a workaround because there is no interface
// for Package Editors by IDEIntf as it is for example for Form Designers.

procedure TDockPackageWindow.OnFormAdded(Sender: TObject; Form: TCustomForm);
begin
  if ( Form.ClassName = 'TPackageEditorForm' ) then begin // Cannot use "is"-keyword
    // here because the class is not exposed via the IDEInterface

    Form.AddHandlerFirstShow( @DoFormDock ); // Add handler instead of docking
    // because ManualDock is called internally when the form becomes visible
  end;
end;


procedure TDockPackageWindow.DoFormDock(Sender: TObject);
var
  Form, ProjInsp: TCustomForm;
begin
  Form:= Sender as TCustomForm;

  ProjInsp:= IDEWindowCreators.GetForm( 'ProjectInspector', True );
  // Get the Project Inspector window

  if ( Assigned( ProjInsp )) then
    Form.ManualDock( ProjInsp.HostDockSite, nil, alClient );
  // Manually dock the form to where the project inspector is docked

  // alClient should be alCustom according to this
  // https://lazarus-ccr.sourceforge.io/docs/lcl/controls/tcontrol.manualdock.html
  // but however it does not work with alCustom

  Form.RemoveHandlerFirstShow( @DoFormDock );
  // Remove the handler again
end;

end.

