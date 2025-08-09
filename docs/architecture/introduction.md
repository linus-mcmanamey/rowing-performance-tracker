# Introduction

This document outlines the complete fullstack architecture for the Rowing Performance Tracking Platform, including backend systems, frontend implementation, and their integration. It serves as the single source of truth for AI-driven development, ensuring consistency across the entire technology stack.

This unified approach combines what would traditionally be separate backend and frontend architecture documents, streamlining the development process for modern fullstack applications where these concerns are increasingly intertwined.

## Starter Template or Existing Project
**Status:** Brownfield iOS project with existing PM5 BLE implementation

The project builds upon an existing iOS codebase that already includes:
- Complete PM5 BLE controller implementation (`d_n_w/PM5/`)
- CSAFE protocol parser for PM5 data
- Data models for all PM5 metrics
- Test view for PM5 connectivity

This existing foundation accelerates MVP development by providing proven BLE connectivity code.

## Change Log
| Date | Version | Description | Author |
|------|---------|-------------|---------|
| 2025-08-09 | 1.0 | Initial architecture document | Winston (Architect) |
| 2025-08-09 | 1.1 | Added self-hosting backend strategy | Winston (Architect) |
| 2025-08-09 | 1.2 | Integrated GitHub Projects management | Winston (Architect) |
| 2025-08-09 | 1.3 | Revised iOS versions for older device support | Winston (Architect) |
