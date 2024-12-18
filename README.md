# Avocado Bootloader

![Avocado Mascot](./assets/mascot.svg)  
*The multi-stage, multi-boot bootloader with UEFI support!*

## Overview

Avocado is a taco-themed, multi-stage, multiboot-compliant bootloader designed to support UEFI systems. Inspired by the modularity and flexibility of modern operating systems, Avocado provides a robust foundation for loading kernels efficiently and reliably.

---

## Features

- **Multiboot Compliant**  
  Fully adheres to the multiboot standard for seamless kernel loading.  

- **UEFI Support**  
  Built for modern systems with native UEFI boot capabilities.  

- **Multi-Stage Boot Process**  
  A clean and efficient three-stage design:
  1. **Seed**: Initialization and basic hardware setup.
  2. **Flesh**: Loading the configuration and environment setup.
  3. **Pit**: Launching the operating system kernel.

- **Multi-Architecture Support**  
  Designed to work on multiple architectures, including x86 and ARM.  

- **Customizable**  
  Easily tailored for various operating systems.  

- **Taco-Themed Fun**  
  Why be boring when you can be delicious?

---

## Project Structure
```plaitext
..
├── Arch
│   └── x86
├── README.md
└── assets
    ├── mascot.svg
    └── tree.log

4 directories, 3 files

```