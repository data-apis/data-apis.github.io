+++
date = "2025-03-19T08:00:00+00:00"
author = "Athan Reines"
title = "2025 release of the Array API Standard"
tags = ["APIs", "standard", "consortium", "arrays", "community"]
categories = ["Consortium", "Standardization"]
description = "The 2025 revision of the array API standard has been finalized and is ready for adoption by conforming array libraries."
draft = false
weight = 30
+++

We're pleased to announce the 2025 revision of the Array API standard.

Since its initial release in 2021, the Array API standard has aimed to reduce
fragmentation across array libraries by defining a common, minimal interface
for multidimensional array operations. Over the past several years, the
standard has matured alongside its ecosystem, with increasing adoption across
libraries such as NumPy, CuPy, PyTorch, JAX, and others.

The 2025 revision marks another step forward in that evolution. This release
focuses on improving usability, clarifying semantics, and addressing feedback
from downstream libraries and users who are building on top of the standard.

## What's new in 2025

This year's revision is less about expanding surface area and more about
refinement. As adoption has grown, so too has the need to ensure that the
specification is both practical and predictable in real-world usage.

### Smoother edges for downstream libraries

One of the primary goals of this revision is to make the standard easier to
implement and depend on.

Over the past year, we've worked closely with maintainers of downstream
libraries, such as SciPy, scikit-learn, and others, to identify friction points
when targeting the Array API. In response, the 2025 revision includes:

- Clarifications to ambiguous or under-specified behaviors.
- Improved consistency across related APIs.
- Better alignment between specification language and existing implementations.

These changes reduce the amount of special-casing required in downstream code
and make it easier to write libraries that are backend-agnostic.

### Continued investment in consistency

Consistency remains a core design principle of the Array API standard. In this
revision, we've continued to refine naming, argument conventions, and behavior
to ensure that APIs feel coherent and predictable. Where inconsistencies or
surprising behaviors were identified in earlier versions, we've taken steps to
resolve them while carefully balancing backward compatibility concerns.

### Expanded and clarified semantics

As more libraries adopt the standard, subtle semantic mismatches become more
visible. The 2025 revision addresses these by:

- Tightening definitions for edge cases.
- Clarifying broadcasting and type promotion behavior.
- Providing more precise guarantees around function outputs and error
  conditions.

These improvements are especially important for authors of numerical libraries,
where small inconsistencies can propagate into larger correctness issues.

### New API Additions

Several new APIs have been introduced in this release to expand functionality
and improve usability:

-   `broadcast_shapes`: broadcasts one or more shapes against one another.
-   `isin`: tests for each element in an array whether the element is in
    another array.
-   `linalg.eig`: returns the eigenvalues and eigenvectors of a real or complex
    matrix.
-   `linalg.eigvals`: returns the eigenvalues of a real or complex matrix.

These additions further close the gap between the Array API standard and
established numerical computing libraries.

### Breaking Changes

With progress comes necessary refinements. This year's update includes one
significant breaking change:

- **Consistently return tuples rather than lists**: Previously, for
  `broadcast_arrays`, `meshgrid`, and `__array_namespace_info__().devices`, the
  functions returned lists. Guidance has now been updated to require always
  returning tuples. Prior guidance originated from early specification
  discussions, and, since that time, array libraries have moved away from
  returning lists to always returning tuples. This change ensures that the
  specification matches ecosystem conventions and further ensures consistency
  throughout the specification.

### Changelog

For a complete list of changes, please see the full changelog:

[https://data-apis.org/array-api/latest/changelog.html](https://data-apis.org/array-api/latest/changelog.html)

## Growing ecosystem adoption

The Array API standard continues to see strong adoption across the scientific
Python ecosystem. Major array libraries have either implemented or are actively
working toward compliance, and an increasing number of downstream libraries are
using the standard as a portability layer. This enables users to write code once
and run it across multiple array backends, including CPU and GPU implementations.

In parallel, the [`array-api-extra`](https://github.com/data-apis/array-api-extra)
project continues to expand, providing higher-level utilities that build
on top of the core specification and address common needs in downstream
libraries and user applications.

## Looking ahead

As the Array API standard matures, our focus is shifting from defining the core
interface to ensuring long-term stability, usability, and ecosystem
integration. Future work will continue to prioritize:

- Improving the developer experience for downstream libraries.
- Ensuring consistency across implementations.
- Expanding supporting tools and libraries around the standard.

We remain committed to working closely with the community to ensure that the
standard evolves in a way that reflects real-world usage and needs.

## Get involved

The Array API standard is developed in the open, and we welcome feedback and
contributions from the community.

- Specification: [https://data-apis.org/array-api/](https://data-apis.org/array-api/)
- GitHub: [https://github.com/data-apis/array-api](https://github.com/data-apis/array-api)
- Public calendar: [https://calendar.google.com/calendar/embed?src=8fe9013a2cb5d3409bb236d04eca73fa5227eac01c02ea8f6bc4a6a3cf982fa3%40group.calendar.google.com](https://calendar.google.com/calendar/embed?src=8fe9013a2cb5d3409bb236d04eca73fa5227eac01c02ea8f6bc4a6a3cf982fa3%40group.calendar.google.com)

If you're building a library, experimenting with backend-agnostic code, or
encountering challenges with the standard, we'd love to hear from you.

## Acknowledgments

This release would not have been possible without the continued efforts of
contributors across the scientific Python ecosystem. We're grateful to everyone
who has provided feedback, implemented the standard, and helped move the
project forward.

### Funding Acknowledgment

This project has been made possible in part by grant number EOSS6-0000000621
from the Chan Zuckerberg Initiative DAF, an advised fund of Silicon Valley
Community Foundation. Athan Reines is the grant's principal investigator and
Quansight, PBC is the entity receiving and executing on the grant.