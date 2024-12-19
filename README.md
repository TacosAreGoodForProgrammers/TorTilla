Here's the updated README with your latest additions and a section for recommendations on Discord channels:

---

# Avocado Bootloader

![Avocado Mascot](./assets/mascot/mascot.svg)  
*The multi-stage, multi-boot bootloader with UEFI support!*

## Overview

Avocado is an avocado-themed, multi-stage, multiboot-compliant bootloader designed to support UEFI systems. Inspired by the modularity and flexibility of modern operating systems, Avocado provides a robust foundation for loading kernels efficiently and reliably.

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
```plaintext
.
├── Arch
│   ├── arm
│   │   ├── stage1
│   │   ├── stage2
│   │   └── stage3
│   └── x86
│       ├── stage1(seed)
│       │   ├── gpt.s
│       │   ├── mbr.s
│       │   └── seed.s
│       ├── stage2(pit)
│       └── stage3(flesh)
│           └── f
├── README.md
├── assets
│   ├── full_tree.log
│   ├── mascot
│   │   ├── mascot.jpg
│   │   ├── mascot.png
│   │   ├── mascot.svg
│   │   ├── mascot_ascii.txt
│   │   └── mascot_ascii_uncolored.txt
│   └── tree.log
├── common
│   ├── stage1
│   ├── stage2
│   └── stage3
└── uefi

18 directories, 11 files
```

---

## Join Us on Discord!

We are building a community around TacoOs, and we'd love for you to join us on Discord! You can ask questions, share ideas, and get updates on the project.

[Join our Discord](https://discord.gg/4R22B5F4)

---
