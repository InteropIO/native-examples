# Native Examples

This repo contains Glue42 COM and Glue42 C Exports examples demonstrating various [**Glue42 Enterprise**](https://glue42.com/enterprise/) functionalities.

## Contents

- `glue-c-exports` - contains the Glue42 C Exports library and C++ and MFC examples using the Glue42 C Exports library. The Glue42 C Exports library offers easy access to Glue42 functionalities via exported C functions. It can be used by any native language that supports external C functions. For more details, see the [Glue42 C Exports documentation](https://docs.glue42.com/getting-started/how-to/glue42-enable-your-app/c-exports/index.html).

- `glue-com` - contains Delphi and MFC examples using the Glue42 COM library. The Glue42 COM library exposes [**Glue42 Enterprise**](https://glue42.com/enterprise/) functionality via COM that can be consumed by VBA, Delphi and C++ apps. For more details, see the Glue42 [COM/VBA](https://docs.glue42.com/getting-started/how-to/glue42-enable-your-app/vba/index.html) and Glue42 [COM/Delphi](https://docs.glue42.com/getting-started/how-to/glue42-enable-your-app/delphi/index.html) documentation.

## Examples

### Glue42 C Exports

- C++ Console example - demonstrates initializing Glue42, registering and invoking Interop methods, and using Shared Contexts and Channels;

- MFC example - demonstrates initializing Glue42, registering the main and child windows as Glue42 windows and as Glue42 app instances, handling save and restore state, handling window and app events;

### Glue42 COM

- Delphi 10 example - demonstrates initializing the Glue42, registering windows, registering and invoking Interop methods, using Interop streams, and using Shared Contexts and Channels;

- Delphi 7 example - demonstrates initializing the Glue42, registering windows, creating applications, registering app factories, registering and invoking Interop methods, and using Shared Contexts and Channels;

- MFC example - demonstrates initializing the Glue42, registering windows, creating applications, saving application state, and using Channels;
