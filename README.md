# LazyModule

**LazyModule** is a small PowerShell utility designed to remove friction
when creating and managing local PowerShell modules during development.

It helps you scaffold a module structure instantly and optionally link
it into your `PSModulePath` using a junction, so you can develop your
module inside your project directory while PowerShell loads it as if it
were installed globally.

------------------------------------------------------------------------

## ✨ Features

-   Quickly scaffold a fully structured PowerShell module
-   Automatically generates:
    -   `.psd1` module manifest
    -   `.psm1` module file
    -   `Public/` and `Private/` folders
-   Optional junction creation inside `PSModulePath`
-   Easy removal of created junctions
-   Git-aware author detection (when available)

------------------------------------------------------------------------

## 📦 Exposed Commands

LazyModule exposes two main functions:

-   `New-LazyModule`
-   `Remove-LazyModule`

------------------------------------------------------------------------

## 🚀 New-LazyModule

### Synopsis

Quickly scaffold a PowerShell module.

### Description

`New-LazyModule` creates a ready-to-use PowerShell module structure
including:

-   Module manifest (`.psd1`)
-   Module file (`.psm1`)
-   `Public` and `Private` directories

Optionally, it creates a **junction** inside your `PSModulePath` that
points to your project folder.

This allows you to: - Keep your module inside a project or Git
repository - Work in your preferred directory - Use the module
immediately without copying files into `PSModulePath`

### Syntax

``` powershell
New-LazyModule [[-Name] <String>] [-Path <String>] [-Author <String>] [-Description <String>] [-NoJunction] [-Force] [<CommonParameters>]
```

------------------------------------------------------------------------

## 🧹 Remove-LazyModule

### Synopsis

Remove the module from the `PSModulePath`.

### Description

`Remove-LazyModule` removes the junction created by `New-LazyModule`,
effectively unlinking the module from the PowerShell module discovery
path.

The original project directory remains untouched.

### Syntax

``` powershell
Remove-LazyModule [[-Name] <String>] [<CommonParameters>]
```

------------------------------------------------------------------------

## 📁 Generated Structure

After running `New-LazyModule`, the project structure looks like:

    AwesomePowerShell/
    │
    ├── AwesomePowerShell.psd1
    ├── AwesomePowerShell.psm1
    │
    ├── Public/
    │   └── (exported functions)
    │
    └── Private/
        └── (internal helpers)

------------------------------------------------------------------------

## 🧠 Why Junctions?

PowerShell normally expects modules inside directories listed in
`PSModulePath`.

Using a junction allows you to:

-   Keep clean project repositories
-   Avoid manual copying
-   Develop modules like normal software projects
-   Instantly test changes

Think of it as a symbolic bridge between *development* and
*installation*.

------------------------------------------------------------------------

## ⚙️ Requirements

-   PowerShell 5.1+ or PowerShell 7+
-   Windows (junction support required)
-   Git (optional, used to detect author information)

------------------------------------------------------------------------

## 👤 Author

**vlgndr**

------------------------------------------------------------------------

## 📄 License

Add your preferred license here (MIT recommended).
