+++
date = "2025-02-27T08:00:00+00:00"
author = "Athan Reines"
title = "2024 release of the Array API Standard"
tags = ["APIs", "standard", "consortium", "arrays", "community"]
categories = ["Consortium", "Standardization"]
description = "The 2024 revision of the array API standard has been finalized and is ready for adoption by conforming array libraries."
draft = false
weight = 30
+++

Another year, another milestone! We're excited to announce the release of the
2024 revision of the Array API Standard, the latest iteration of our ongoing
efforts to unify and standardize array programming across the PyData ecosystem.
Since the standard's inception, our goal has been to facilitate
interoperability between array libraries and enable a more consistent and
predictable developer experience. This year's update continues that mission
with key enhancements, new features, and clarifications that reflect the needs
of the community.

## Key Enhancements in v2024.12

### Scalar Argument Support

Previously, binary element-wise functions, such as `add`, `mul`, and others,
required both input arguments to be arrays. This constraint has now been
relaxed: scalars are now allowed as arguments, as long as at least one argument
is an array. This change aligns with common practices in numerical computing
workflows and makes it easier to write concise, readable code.

### Integer Array Indexing

Portable indexing semantics just got more powerful! The 2024 revision of the
standard introduces support for indexing an array using tuples consisting
solely of integers and integer arrays. This feature—a subset of NumPy's
vectorized fancy indexing—was a highly requested addition from downstream
users. It enables efficient random sampling and more flexible multi-dimensional
indexing, making it easier to work with large datasets and tensors.

For more details, see [_Integer Array Indexing_](https://data-apis.org/array-api/latest/API_specification/indexing.html#integer-array-indexing)
in the specification.

### New API Additions

Several new APIs have been introduced in this release to expand functionality
and improve usability:

-   `count_nonzero`: counts the number of nonzero elements in an array.
-   `cumulative_prod`: computes the cumulative product along a specified axis.
-   `take_along_axis`: selects elements from an array using indices along a
    given axis.
-   `diff`: computes the discrete difference between consecutive elements.
-   `nextafter`: returns the next representable floating-point value in the
    direction of another floating-point value.

These additions further close the gap between the Array API Standard and
established numerical computing libraries.

### Breaking Changes

With progress comes necessary refinements. This year's update includes two
significant breaking changes:

-   **Device-aware type promotion**: The guidance for `result_type` and `can_cast`
    has been updated to require that type promotion rules account for device
    contexts when at least one operand is an array. This ensures that type
    promotion can be correctly handled across different hardware environments
    and accurately reflect device capabilities.
-   **Refined handling of Python complex scalars**: Previously, for binary
    operations involving an array and a Python scalar, the standard required
    that all scalar values be automatically converted to zero-dimensional
    arrays of the same type as the array operand. Now, if a Python `complex`
    scalar is used in an operation (e.g., `x * 1j`), the real-valued array
    operand should be promoted to a complex floating-point type of the same
    precision as the original array operand. This change better aligns with
    practical use cases involving complex numbers and helps improve developer
    ergonomics.

### Specification Clarifications

Standards evolve not just through feature additions but also through
refinements. Over the past year, we've worked closely with implementers and
downstream users to resolve ambiguities in the specification. These
clarifications ensure that adopting the standard is as seamless as possible and
that behavior is well-defined across implementations.

## Looking Ahead

The 2024 revision of the Array API Standard represents another step forward in
making array interoperability a reality across the Python ecosystem. Every
iteration of the standard reflects deep collaboration across the PyData
community, with contributions from library maintainers, researchers, and
practitioners.

We encourage all implementers to adopt the latest version and welcome feedback
from the community. If you're interested in contributing to future discussions,
check out the [specification repository](https://github.com/data-apis/array-api)
and get involved!

For full details on this release, see the [changelog](https://data-apis.org/array-api/latest/changelog.html#v2024-12).

Here's to another year of advancing the frontier of array and tensor computing
in Python!
