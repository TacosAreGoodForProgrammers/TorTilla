### Key Functions of Stage 1
1. **Initialize Real Mode Environment:**
   - Clears interrupts and sets segment registers (`DS`, `ES`) to 0.
   - Prepares for disk operations and basic string handling.

2. **Detect Partition Table Type (GPT or MBR):**
   - Attempts to read the **GPT Header** from Logical Block Address (LBA) 1 (sector 2).
   - Verifies the **GPT signature** (`"EFI PART"`) to confirm a GPT disk.
   - If GPT is not found, reads the **MBR** from LBA 0 (sector 1).
   - Checks the **MBR boot signature** (`0xAA55`) to confirm an MBR disk.

3. **Output Status Messages:**
   - Displays appropriate messages for detection outcomes:
     - `"GPT Disk Found."` if GPT is detected.
     - `"MBR Disk Found."` if MBR is detected.
     - `"No valid partition table found!"` if neither is detected.
     - `"Disk read error!"` for any disk read failure.

4. **Error Handling:**
   - If a disk read fails (carry flag set), it jumps to a `disk_error` handler and halts the system.
   - If neither GPT nor MBR is detected, an error message is displayed, and execution halts.

5. **Prepare for Stage 2:**
   - Placeholder `continue_boot` points to the next stage (`pit`) where partitions are processed and the kernel is loaded.

---

### Planned Enhancements
- **Additional Documentation:** Add comments explaining:
  - Key registers used (e.g., `AH`, `AL`, `CH`, etc.).
  - Memory locations (`0x600`) and their purposes.
  - BIOS interrupt specifics (e.g., `INT 0x13` and `INT 0x10`).
- **Improved Error Handling:** Distinguish between GPT and MBR read errors and undefined partition table errors.
- **Stage 2 Integration:** Provide placeholders or hooks for loading and processing partitions.
- **Refactor Code Structure:** Separate GPT and MBR detection routines for clarity and modularity.

