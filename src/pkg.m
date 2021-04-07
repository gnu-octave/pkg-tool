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
## @deftypefn  {} {} pkg @var{command} @var{pkg_name}
## @deftypefnx {} {} pkg @var{command} @var{option} @var{pkg_name}
## @deftypefnx {} {[@var{out1}, @dots{}] =} pkg (@var{command}, @dots{} )
## Manage or query packages (groups of add-on functions) for Octave.
##
## Packages can be installed globally (i.e., for all users of the system) or
## locally (i.e., for the current user only).
##
## Global packages are installed by default in a system-wide location.  This is
## usually a subdirectory of the folder where Octave itself is installed.
## Therefore, Octave needs write access to this folder to install global
## packages.  That usually means that Octave has to run with root access (or
## "Run as administrator" on Windows) to be able to install packages globally.
##
## In contrast, local packages are installed by default in the user's
## home directory (profile on Windows) and are only available to that specific
## user.  Usually, they can be installed without root access (or administrative
## privileges).
##
## For global and local packages, there are separate databases holding the
## information about the installed packages.  If some package is installed
## globally as well as locally, the local installation takes precedence over
## ("shadows") the global one.  Which package installation (global or local) is
## used can also be manipulated by using prefixes and/or using the
## @samp{local_list} input argument.  Using these mechanisms, several different
## releases of one and the same package can be installed side by side as well
## (but cannot be loaded simultaneously).
##
## Packages might depend on external software and/or other packages.  To be
## able to install such packages, these dependencies should be installed
## beforehand.  A package that depends on other package(s) can still be
## installed using the @option{-nodeps} flag.  The effects of unsatisfied
## dependencies on external software---like libraries---depends on the
## individual package.
##
## Packages must be loaded before they can be used.  When loading a package,
## Octave performs the following tasks:
## @enumerate
## @item
## If the package depends on other packages (and @code{pkg load} is called
## without the @option{-nodeps} option), the package is not loaded
## immediately.  Instead, those dependencies are loaded first (recursively if
## needed).
##
## @item
## When all dependencies are satisfied, the package's subdirectories are
## added to the search path.
## @end enumerate
##
## This load order leads to functions that are provided by dependencies being
## potentially shadowed by functions of the same name that are provided by
## top-level packages.
##
## Each time, a package is added to the search path, initialization script(s)
## for the package are automatically executed if they are provided by the
## package.
##
## Depending on the value of @var{command} and on the number of requested
## return arguments, @code{pkg} can be used to perform several tasks.
## Possible values for @var{command} are:
##
## @table @samp
##
## @item install
## Install named packages.  For example,
##
## @example
## pkg install image-1.0.0.tar.gz
## @end example
##
## @noindent
## installs the package found in the file @file{image-1.0.0.tar.gz}.  The
## file containing the package can be a URL, e.g.,
##
## @example
## pkg install 'http://somewebsite.org/image-1.0.0.tar.gz'
## @end example
##
## @noindent
## installs the package found in the given URL@.  This
## requires an internet connection and the cURL library.
##
## @noindent
## @emph{Security risk}: no verification of the package is performed
## before the installation.  It has the same security issues as manually
## downloading the package from the given URL and installing it.
##
## @noindent
## @emph{No support}: the GNU Octave community is not responsible for
## packages installed from foreign sites.  For support or for
## reporting bugs you need to contact the maintainers of the installed
## package directly (see the @file{DESCRIPTION} file of the package)
##
## The @var{option} variable can contain options that affect the manner
## in which a package is installed.  These options can be one or more of
##
## @table @code
## @item -nodeps
## The package manager will disable dependency checking.  With this option it
## is possible to install a package even when it depends on another package
## which is not installed on the system.  @strong{Use this option with care.}
##
## @item -local
## A local installation (package available only to current user) is forced,
## even if the user has system privileges.
##
## @item -global
## A global installation (package available to all users) is forced, even if
## the user doesn't normally have system privileges.
##
## @item -forge
## Install a package directly from the Octave Forge repository.  This
## requires an internet connection and the cURL library.
##
## @emph{Security risk}: no verification of the package is performed
## before the installation.  There are no signature for packages, or
## checksums to confirm the correct file was downloaded.  It has the
## same security issues as manually downloading the package from the
## Octave Forge repository and installing it.
##
## @item -verbose
## The package manager will print the output of all commands as
## they are performed.
## @end table
##
## @item update
## Check installed Octave Forge packages against repository and update any
## outdated items.  This requires an internet connection and the cURL library.
## Usage:
##
## @example
## pkg update
## @end example
##
## @noindent
## To update a single package use @code{pkg install -forge}
##
## @item uninstall
## Uninstall named packages.  For example,
##
## @example
## pkg uninstall image
## @end example
##
## @noindent
## removes the @code{image} package from the system.  If another installed
## package depends on the @code{image} package an error will be issued.
## The package can be uninstalled anyway by using the @option{-nodeps} option.
##
## @item load
## Add named packages to the path.  After loading a package it is
## possible to use the functions provided by the package.  For example,
##
## @example
## pkg load image
## @end example
##
## @noindent
## adds the @code{image} package to the path.
##
## Note: When loading a package, @code{pkg} will automatically try to load
## any unloaded dependencies as well, unless the @option{-nodeps} flag has
## been specified.  For example,
##
## @example
## pkg load signal
## @end example
##
## @noindent
## adds the @code{signal} package and also tries to load its dependency: the
## @code{control} package.  Be aware that the functionality of package(s)
## loaded will probably be impacted by use of the @option{-nodeps} flag.  Even
## if necessary dependencies are loaded later, the functionality of top-level
## packages can still be affected because the optimal loading order may not
## have been followed.
##
## @item unload
## Remove named packages from the path.  After unloading a package it is
## no longer possible to use the functions provided by the package.  Trying
## to unload a package that other loaded packages still depend on will result
## in an error; no packages will be unloaded in this case.  A package can
## be forcibly removed with the @option{-nodeps} flag, but be aware that the
## functionality of dependent packages will likely be affected.  As when
## loading packages, reloading dependencies after having unloaded them with the
## @option{-nodeps} flag may not restore all functionality of the dependent
## packages as the required loading order may be incorrect.
##
## @item list
## Show the list of currently installed packages.  For example,
##
## @example
## pkg list
## @end example
##
## @noindent
## will produce a short report with the package name, version, and installation
## directory for each installed package.  Supply a package name to limit
## reporting to a particular package.  For example:
##
## @example
## pkg list image
## @end example
##
## If a single return argument is requested then @code{pkg} returns a cell
## array where each element is a structure with information on a single
## package.
##
## @example
## installed_packages = pkg ("list")
## @end example
##
## If two output arguments are requested @code{pkg} splits the list of
## installed packages into those which were installed by the current user,
## and those which were installed by the system administrator.
##
## @example
## [user_packages, system_packages] = pkg ("list")
## @end example
##
## The @qcode{"-forge"} option lists packages available at the Octave Forge
## repository.  This requires an internet connection and the cURL library.
## For example:
##
## @example
## oct_forge_pkgs = pkg ("list", "-forge")
## @end example
##
## @item describe
## Show a short description of installed packages.  With the option
## @qcode{"-verbose"} also list functions provided by the package.  For
## example,
##
## @example
## pkg describe -verbose
## @end example
##
## @noindent
## will describe all installed packages and the functions they provide.
## Display can be limited to a set of packages:
##
## @example
## @group
## ## describe control and signal packages
## pkg describe control signal
## @end group
## @end example
##
## If one output is requested a cell of structure containing the
## description and list of functions of each package is returned as
## output rather than printed on screen:
##
## @example
## desc = pkg ("describe", "secs1d", "image")
## @end example
##
## @noindent
## If any of the requested packages is not installed, @code{pkg} returns an
## error, unless a second output is requested:
##
## @example
## [desc, flag] = pkg ("describe", "secs1d", "image")
## @end example
##
## @noindent
## @var{flag} will take one of the values @qcode{"Not installed"},
## @qcode{"Loaded"}, or
## @qcode{"Not loaded"} for each of the named packages.
##
## @item prefix
## Set the installation prefix directory.  For example,
##
## @example
## pkg prefix ~/my_octave_packages
## @end example
##
## @noindent
## sets the installation prefix to @file{~/my_octave_packages}.
## Packages will be installed in this directory.
##
## It is possible to get the current installation prefix by requesting an
## output argument.  For example:
##
## @example
## pfx = pkg ("prefix")
## @end example
##
## The location in which to install the architecture dependent files can be
## independently specified with an addition argument.  For example:
##
## @example
## pkg prefix ~/my_octave_packages ~/my_arch_dep_pkgs
## @end example
##
## @item local_list
## Set the file in which to look for information on locally
## installed packages.  Locally installed packages are those that are
## available only to the current user.  For example:
##
## @example
## pkg local_list ~/.octave_packages
## @end example
##
## It is possible to get the current value of local_list with the following
##
## @example
## pkg local_list
## @end example
##
## @item global_list
## Set the file in which to look for information on globally
## installed packages.  Globally installed packages are those that are
## available to all users.  For example:
##
## @example
## pkg global_list /usr/share/octave/octave_packages
## @end example
##
## It is possible to get the current value of global_list with the following
##
## @example
## pkg global_list
## @end example
##
## @item build
## Build a binary form of a package or packages.  The binary file produced
## will itself be an Octave package that can be installed normally with
## @code{pkg}.  The form of the command to build a binary package is
##
## @example
## pkg build builddir image-1.0.0.tar.gz @dots{}
## @end example
##
## @noindent
## where @code{builddir} is the name of a directory where the temporary
## installation will be produced and the binary packages will be found.
## The options @option{-verbose} and @option{-nodeps} are respected, while
## all other options are ignored.
##
## @item rebuild
## Rebuild the package database from the installed directories.  This can
## be used in cases where the package database has been corrupted.
##
## @item test
## Perform the built-in self tests contained in all functions provided by
## the named packages.  For example:
##
## @example
## pkg test image
## @end example
##
## @end table
## @seealso{ver, news}
## @end deftypefn

function [local_packages, global_packages] = pkg (varargin)

  opts = parse_pkg_arguments ("none", varargin);

  confirm_recursive_rmdir (false, "local");

  if (octave_forge && ! any (strcmp (action, {"install", "list"})))
    error ("pkg: '-forge' can only be used with install or list");
  endif

  ## Take action
  switch (action)
    case "list"
      if (octave_forge)
        if (nargout)
          local_packages = list_forge_packages ();
        else
          list_forge_packages ();
        endif
      else
        if (nargout == 1)
          local_packages = installed_packages (local_list, global_list, files);
        elseif (nargout > 1)
          [local_packages, global_packages] = installed_packages (local_list,
                                                                  global_list,
                                                                  files);
        else
          installed_packages (local_list, global_list, files);
        endif
      endif

    case "install"
      if (isempty (files))
        error ("pkg: install action requires at least one filename");
      endif

      local_files = {};
      tmp_dir = tempname ();
      unwind_protect

        if (octave_forge)
          [urls, local_files] = cellfun ("get_forge_download", files,
                                         "uniformoutput", false);
          [files, succ] = cellfun ("urlwrite", urls, local_files,
                                   "uniformoutput", false);
          succ = [succ{:}];
          if (! all (succ))
            i = find (! succ, 1);
            error ("pkg: could not download file %s from URL %s",
                   local_files{i}, urls{i});
          endif
        else
          ## If files do not exist, maybe they are not local files.
          ## Try to download them.
          not_local_files = cellfun (@(x) isempty (glob (x)), files);
          if (any (not_local_files))
            [success, msg] = mkdir (tmp_dir);
            if (success != 1)
              error ("pkg: failed to create temporary directory: %s", msg);
            endif

            for file = files(not_local_files)
              file = file{1};
              [~, fname, fext] = fileparts (file);
              tmp_file = fullfile (tmp_dir, [fname fext]);
              local_files{end+1} = tmp_file;
              looks_like_url = regexp (file, '^\w+://');
              if (looks_like_url)
                [~, success, msg] = urlwrite (file, local_files{end});
                if (success != 1)
                  error ("pkg: failed downloading '%s': %s", file, msg);
                endif
              else
                looks_like_pkg_name = regexp (file, '^[\w-]+$');
                if (looks_like_pkg_name)
                  error (["pkg: file not found: %s.\n" ...
                          "This looks like an Octave Forge package name." ...
                          "  Did you mean:\n" ...
                          "       pkg install -forge %s"], ...
                         file, file);
                else
                  error ("pkg: file not found: %s", file);
                endif
              endif
              files{strcmp (files, file)} = local_files{end};

            endfor
          endif
        endif
        pkg_install (files, deps, prefix, archprefix, verbose, local_list,
                     global_list, global_install);

      unwind_protect_cleanup
        [~] = cellfun ("unlink", local_files);
        if (exist (tmp_dir, "file"))
          [~] = rmdir (tmp_dir, "s");
        endif
      end_unwind_protect

    case "uninstall"
      pkg_uninstall (files, deps, verbose, local_list, global_list, global_install);

    case "load"
      pkg_load (files, deps, local_list, global_list);

    case "unload"
      pkg_unload (files, deps, local_list, global_list);

    case "prefix"
      if (isempty (files) && ! nargout)
        printf ("Installation prefix:             %s\n", prefix);
        printf ("Architecture dependent prefix:   %s\n", archprefix);
      elseif (isempty (files) && nargout)
        local_packages = prefix;
        global_packages = archprefix;
      elseif (numel (files) >= 1 && ischar (files{1}))
        prefix = tilde_expand (files{1});
        local_packages = prefix = make_absolute_filename (prefix);
        user_prefix = true;
        if (numel (files) >= 2 && ischar (files{2}))
          archprefix = make_absolute_filename (tilde_expand (files{2}));
        endif
      else
        error ("pkg: prefix action requires a directory input, or an output argument");
      endif

    case "local_list"
      pkg_local_list (varargin{1});

    case "global_list"
      if (isempty (files) && ! nargout)
        disp (global_list);
      elseif (isempty (files) && nargout)
        local_packages = global_list;
      elseif (numel (files) == 1 && ! nargout && ischar (files{1}))
        global_list = files{1};
        if (! exist (global_list, "file"))
          try
            ## Force file to be created
            fclose (fopen (files{1}, "wt"));
          catch
            error ("pkg: cannot create file %s", global_list);
          end_try_catch
        endif
        global_list = canonicalize_file_name (global_list);
      else
        error ("pkg: specify a global_list file, or request an output argument");
      endif

    case "rebuild"
      if (global_install)
        global_packages = pkg_rebuild (prefix, archprefix, global_list, files,
                                       verbose);
        global_packages = save_order (global_packages);
        if (ispc)
          ## On Windows ensure LFN paths are saved rather than 8.3 style paths
          global_packages = standardize_paths (global_packages);
        endif
        global_packages = make_rel_paths (global_packages);
        save (global_list, "global_packages");
        if (nargout)
          local_packages = global_packages;
        endif
      else
        local_packages = pkg_rebuild (prefix, archprefix, local_list, files,
                                      verbose);
        local_packages = save_order (local_packages);
        if (ispc)
          local_packages = standardize_paths (local_packages);
        endif
        save (local_list, "local_packages");
        if (! nargout)
          clear ("local_packages");
        endif
      endif

    case "build"
      build (files, verbose);

    case "describe"
      ## FIXME: name of the output variables is inconsistent with their content
      if (nargout)
        [local_packages, global_packages] = pkg_describe (files, verbose,
                                                          local_list,
                                                          global_list);
      else
        pkg_describe (files, verbose, local_list, global_list);
      endif

    case "update"
      installed_pkgs_lst = installed_packages (local_list, global_list);

      ## Explicit list of packages to update, rather than all packages
      if (numel (files) > 0)
        update_lst = {};
        installed_names = cellfun (@(idx) idx.name, installed_pkgs_lst,
                                   "UniformOutput", false);
        for i = 1:numel (files)
          idx = find (strcmp (files{i}, installed_names), 1);
          if (isempty (idx))
            warning ("pkg: package %s is not installed - skipping update",
                     files{i});
          else
            update_lst = [ update_lst, installed_pkgs_lst(idx) ];
          endif
        endfor
        installed_pkgs_lst = update_lst;
      endif

      for i = 1:numel (installed_pkgs_lst)
        installed_pkg_name = installed_pkgs_lst{i}.name;
        installed_pkg_version = installed_pkgs_lst{i}.version;
        try
          forge_pkg_version = get_forge_pkg (installed_pkg_name);
        catch
          warning ("pkg: package %s not found on Octave Forge - skipping update\n",
                   installed_pkg_name);
          forge_pkg_version = "0";
        end_try_catch
        if (compare_versions (forge_pkg_version, installed_pkg_version, ">"))
          feval (@pkg, "install", "-forge", installed_pkg_name);
        endif
      endfor

    case "test"
      if (isempty (files))
        error ("pkg: test action requires at least one package name");
      endif
      ## Make sure the requested packages are loaded
      orig_path = path ();
      pkg_load (files, deps, local_list, global_list);
      ## Test packages one by one
      installed_pkgs_lst = installed_packages (local_list, global_list, files);
      unwind_protect
        for i = 1:numel (installed_pkgs_lst)
          printf ("Testing functions in package '%s':\n", files{i});
          installed_pkgs_dirs = {installed_pkgs_lst{i}.dir, ...
                                 installed_pkgs_lst{i}.archprefix};
          installed_pkgs_dirs = ...
            installed_pkgs_dirs (! cellfun (@isempty, installed_pkgs_dirs));
          ## For local installs installed_pkgs_dirs contains the same subdirs
          installed_pkgs_dirs = unique (installed_pkgs_dirs);
          if (! isempty (installed_pkgs_dirs))
            ## FIXME invoke another test routine once that is available.
            ## Until then __run_test_suite__.m will do the job fine enough
            __run_test_suite__ ({installed_pkgs_dirs{:}}, {});
          endif
        endfor
      unwind_protect_cleanup
        ## Restore load path back to its original value before loading packages
        path (orig_path);
      end_unwind_protect

    otherwise
      error ("pkg: invalid action.  See 'help pkg' for available actions");
  endswitch

endfunction


function [url, local_file] = get_forge_download (name)
  [ver, url] = get_forge_pkg (name);
  local_file = tempname (tempdir (), [name "-" ver "-"]);
  local_file = [local_file ".tar.gz"];
endfunction


function [ver, url] = get_forge_pkg (name)

## Try to discover the current version of an Octave Forge package from the web,
## using a working internet connection and the urlread function.
## If two output arguments are requested, also return an address from which
## to download the file.

  ## Verify that name is valid.
  if (! (ischar (name) && rows (name) == 1 && ndims (name) == 2))
    error ("get_forge_pkg: package NAME must be a string");
  elseif (! all (isalnum (name) | name == "-" | name == "." | name == "_"))
    error ("get_forge_pkg: invalid package NAME: %s", name);
  endif

  name = tolower (name);

  ## Try to download package's index page.
  [html, succ] = urlread (sprintf ("https://packages.octave.org/%s/index.html",
                                   name));
  if (succ)
    ## Remove blanks for simpler matching.
    html(isspace (html)) = [];
    ## Good.  Let's grep for the version.
    pat = "<tdclass=""package_table"">PackageVersion:</td><td>([\\d.]*)</td>";
    t = regexp (html, pat, "tokens");
    if (isempty (t) || isempty (t{1}))
      error ("get_forge_pkg: could not read version number from package's page");
    else
      ver = t{1}{1};
      if (nargout > 1)
        ## Build download string.
        pkg_file = sprintf ("%s-%s.tar.gz", name, ver);
        url = ["https://packages.octave.org/download/" pkg_file];
        ## Verify that the package string exists on the page.
        if (isempty (strfind (html, pkg_file)))
          warning ("get_forge_pkg: download URL not verified");
        endif
      endif
    endif
  else
    ## Try get the list of all packages.
    [html, succ] = urlread ("https://packages.octave.org/list_packages.php");
    if (! succ)
      error ("get_forge_pkg: could not read URL, please verify internet connection");
    endif
    t = strsplit (html);
    if (any (strcmp (t, name)))
      error ("get_forge_pkg: package NAME exists, but index page not available");
    endif
    ## Try a simplistic method to determine similar names.
    function d = fdist (x)
      len1 = length (name);
      len2 = length (x);
      if (len1 <= len2)
        d = sum (abs (name(1:len1) - x(1:len1))) + sum (x(len1+1:end));
      else
        d = sum (abs (name(1:len2) - x(1:len2))) + sum (name(len2+1:end));
      endif
    endfunction
    dist = cellfun ("fdist", t);
    [~, i] = min (dist);
    error ("get_forge_pkg: package not found: ""%s"".  Maybe you meant ""%s?""",
           name, t{i});
  endif

endfunction


function list = list_forge_packages ()

  [list, succ] = urlread ("https://packages.octave.org/list_packages.php");
  if (! succ)
    error ("pkg: could not read URL, please verify internet connection");
  endif

  list = ostrsplit (list, " \n\t", true);

  if (nargout == 0)
    ## FIXME: This is a convoluted way to get the latest version number
    ##        for each package in less than 56 seconds (bug #39479).

    ## Get the list of all packages ever published
    [html, succ] = urlread ('https://sourceforge.net/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases');

    if (! succ)
      error ("pkg: failed to fetch list of packages from sourceforge.net");
    endif

    ## Scrape the HTML
    ptn = '<tr\s+title="(.*?gz)"\s+class="file';
    [succ, tok] = regexp (html, ptn, "start", "tokens");
    if (isempty (succ))
      error ("pkg: failed to parse list of packages from sourceforge.net");
    endif

    ## Remove version numbers and produce unique list of packages
    files = cellstr (tok);
    pkg_names = cellstr (regexp (files, '^.*?(?=-\d)', "match"));
    [~, idx] = unique (pkg_names, "first");
    files = files(idx);

    page_screen_output (false, "local");
    puts ("Octave Forge provides these packages:\n");
    for i = 1:length (list)
      pkg_nm = list{i};
      idx = regexp (files, sprintf ('^%s(?=-\\d)', pkg_nm));
      idx = ! cellfun (@isempty, idx);
      if (any (idx))
        ver = regexp (files{idx}, '\d+\.\d+\.\d+', "match"){1};
      else
        ver = "unknown";
      endif
      printf ("  %s %s\n", pkg_nm, ver);
    endfor
  endif

endfunction
