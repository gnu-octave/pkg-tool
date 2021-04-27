########################################################################
##
## Copyright (C) 2005-2021 The Octave Project Developers
##
## See the file COPYRIGHT.md in the top-level directory of this
## distribution or <https://octave.org/copyright/>.
##
## This file is part of Octave.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.
##
########################################################################

## -*- texinfo -*-
## @deftypefn {} {@var{list_file} =} pkg_global_list (@var{list_file})
## Get or set the file containing the list of globally installed packages.
##
## Globally installed packages are available to all users.
## For example getting
##
## @example
## list_file = pkg_global_list ()
## @end example
##
## and setting the file
##
## @example
## pkg_global_list ("/usr/share/octave/octave_packages")
## @end example
## @end deftypefn

function out_file = pkg_global_list (varargin)

  persistent global_list = fullfile (OCTAVE_HOME (), "share", "octave",
                                     "octave_packages");

  ## Do not get removed from memory, even if "clear" is called.
  mlock ();

  params = parse_parameter ({}, varargin{:});
  if (! isempty (params.error))
    error ("pkg_global_list: %s\n\n%s\n\n", params.error, ...
      help ("pkg_global_list"));
  endif

  if (! isempty (params.flags) || (numel (params.in) > 1))
    print_usage ();
  endif

  if (numel (params.in) == 1)
    list_file = params.in{1};
    if (! ischar (list_file))
      error ("pkg: invalid global_list file");
    endif
    list_file = tilde_expand (list_file);
    if (! exist (list_file, "file"))
      try
        ## Force file to be created
        fclose (fopen (list_file, "wt"));
      catch
        error ("pkg: cannot create file %s", list_file);
      end_try_catch
    endif
    global_list = canonicalize_file_name (list_file);
  endif

  if ((nargout == 0) && isempty (params.in))
    disp (global_list);
  else
    out_file = global_list;
  endif

endfunction