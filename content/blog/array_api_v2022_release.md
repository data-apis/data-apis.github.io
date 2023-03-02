+++
date = "2023-03-01T08:00:00+00:00"
author = "Athan Reines"
title = "2022 release of the Array API Standard"
tags = ["APIs", "standard", "consortium", "arrays", "community"]
categories = ["Consortium", "Standardization"]
description = "The 2022 revision of the array API standard has been finalized and is ready for adoption by conforming array libraries."
draft = false
weight = 30
+++

Today marks another significant milestone for the Consortium for Python Data
API Standards. We're excited to announce the release of the 2022 revision of
the Array API Standard. This release is a culmination of extensive discussion
and coordination among array libraries to build on the [initial 2021
release](https://data-apis.org/blog/array_api_standard_release/) of the Array
API Standard and to continue reaching consensus on unified API design and
behavior among array libraries within the PyData ecosystem.

Multi-dimensional arrays (a.k.a. tensors) are the fundamental data structure
for many scientific and numerical computing applications, and the PyData
ecosystem has a rich set of libraries for working with arrays, including NumPy,
CuPy, Dask, PyTorch, MXNet, JAX, TensorFlow, and beyond. Historically,
interoperation among array libraries has been challenging due to divergent API
designs and subtle variation in behavior such that code written for one array
library cannot be readily ported to another array library. To address these
challenges, the Consortium for Python Data API Standards was established to
facilitate coordination among array and dataframe library maintainers,
sponsoring organizations, and key stakeholders and to provide a transparent and
inclusive process--with input from the broader Python community--for
standardizing array API design.

## Brief Timeline

The Consortium was established in May, 2020, and work immediately began to
identify key pain points among array libraries and to research usage patterns
to help inform future API design. In the fall of 2020, we released an initial
draft of the array API specification and sought input from the broader PyData
ecosystem during an extended community review period.

During the community review period, we incorporated community feedback and
continued iterating on existing API design. To facilitate community adoption of
the array API standard, we worked with the NumPy community to implement a
conforming reference implementation. The CuPy, PyTorch, and MXNet communities
built upon this work and soon began efforts to adopt the array API in their own
array libraries.

Throughout 2021, we engaged in a tight feedback loop with array API adopters to
refine and improve the initial draft specification. With each tweak to the
specification, we continued our efforts to provide a portable [test
suite](https://github.com/data-apis/array-api-tests) for testing compliance
with the array API standard. During this time, we also introduced a data
interchange protocol based on [DLPack](https://github.com/dmlc/dlpack) to
facilitate zero-copy memory exchange between array libraries.

In addition to a core set of API designs for array creation, mutation, and
element-wise computation, we introduced "extensions". Extensions are defined as
coherent sets of functionality that are commonly implemented across array
libraries. In contrast to the set of "core" specification-defined APIs,
conforming array libraries are not required to implement extensions, as some
extension APIs may pose an undue development burden due to device constraints,
algorithmic complexity, or other library-specific considerations. The first
extension included in the specification was the `linalg` extension, which
defines a set of linear algebra APIs for computing eigenvalues, performing
singular value decomposition, solving a system of linear equations, and other
linear algebra operations.

By the end of 2021, we neared completion of the first official release of the
Array API Standard. And after some last minute (and rather thorny) concerns
delayed finalization (looking at you copy-view mutability!), we were finally
able to tag the 2021 revision in April, 2022. Phew! And hurray!

## 2022 Revision

After finalizing the 2021 revision of the Array API Standard, we began in
earnest on the 2022 revision with the ambitious goal to finalize its release by
year's end. We had two key objectives: 1) standardize complex number support
and 2) standardize an extension for Fast Fourier Transforms (FFTs).

Complex numbers have a wide range of applications, including signal processing,
control theory, quantum mechanics, fluid dynamics, linear algebra, cartography,
and in various other physics domains. Up until recently, complex number support
among array libraries was spotty, at best, due to additional algorithmic
complexity and lack of device support, something which especially limited
GPU-based accelerator libraries. However, the tide began to change in recent
years as array libraries sought to replicate additional APIs found in NumPy in
their own libraries and device support steadily increased.

During our work on the 2021 revision, standardizing complex number behavior was
one of the top requests from the community; however, array libraries, such as
CuPy and PyTorch, were still in the process of adding full complex number
support across their APIs. Given the still evolving landscape across the
ecosystem, we wanted to avoid prematurely constraining API design before full
consideration of the real-world experience gained while attempting to support
complex numbers across heterogeneous platforms and device types, and we wanted
to allow array libraries the flexibility to continue experimenting with API
design choices.

By the time we put the finishing touches on the 2021 revision, we had enough
data, cross-library experience, and insight to chart a path forward. Helping
motivate this initiative were two desires. First, several linear algebra APIs
specified in the `linalg` extension, such as those for eigenvalue
decomposition, singular value decomposition, and Cholesky decomposition,
required complex number support in order to be full-featured. And second, if we
wanted to standardize APIs for computing Fast Fourier Transforms (FFTs), we
needed complex numbers.

FFTs are a class of algorithms for computing the discrete Fourier transform
(DFT) of a sequence, or its inverse (IDFT), and are widely used in signal
processing applications in engineering, music, science, and mathematics. As
array libraries added complex number support, FFT APIs followed close behind.
Luckily for us, FFT API design was fairly consistent across the ecosystem,
making these APIs good candidates for standardization.

With our priorities set, the 6 months following the 2021 revision were
comprised of requirements gathering, API design iteration, and engaging
community stakeholders. One of the significant challenges in specifying complex
number behavior for element-wise algebraic and transcendental functions was the
absence of a widely followed specification equivalent to the IEEE 754
specification for real-valued floating-point numbers. In particular, how and
where to choose branch cuts and how to handle complex floating-point infinity
remain matters of choice, with equally valid arguments to be made for following
different conventions. In the end, we made the decision to adhere to C99
semantics, as this was the dominant convention among array libraries, with
allowance for divergent behavior in a small number of special cases.

In addition to complex number support and FFTs, the 2022 revision specifies
`take` for returning an arbitrary list of elements along a specified axis.
Standardizing this API was a high priority request among downstream array API
consumers, such as scikit-learn, which commonly use `take` for sampling
multi-dimensional arrays. And one other notable addition was the inclusion of
`isdtype`, which provides a consistent API across array libraries for testing
whether a provided data type is of a specified data type kind--something that,
prior to this specification, was widely divergent across array libraries, thus
making `isdtype` a definite ergonomic and portability win.

The full list of API additions, updates, and errata can be found in the
specification
[changelog](https://github.com/data-apis/array-api/blob/main/CHANGELOG.md).

## Facilitating Array API Adoption

Array API adoption requires buy-in from both array libraries and the downstream
consumers of those libraries. As such, adoption faces two key challenges.
First, to facilitate development, array libraries need a robust mechanism for
determining whether they are specification compliant. Second, while array
libraries work to become fully specification compliant, downstream libraries
need to be able to target a stable compatibility layer in order to smooth over
subtle differences in array library behavior.

To address the first challenge, we've released a comprehensive portable [test
suite](https://github.com/data-apis/array-api-tests) built on Pytest and
Hypothesis for testing Array API Standard compliance. The test suite supports
custom configurations in order to accommodate library-specific specification
deviations and supports vendoring, thus allowing array libraries to easily
include the test suite alongside their existing tests. Upon running the test
suite, the test suite provides a detailed overview of specification compliance,
providing a handy benchmark as array libraries work to iteratively improve
their compliance score.

To address the second challenge, we've released an [array compatibility
layer](https://github.com/data-apis/array-api-compat) which provides a small
wrapper around existing array libraries to ensure Array API Standard compliant
behavior. Using the compatibility layer is as simple as updating your imports.
For example, instead of

```python
import numpy as np
```

do

```python
import array_api_compat.numpy as np
```

And instead of

```python
import cupy as cp
```

do

```python
import array_api_compat.cupy as cp
```

Each import includes all the functions from the normal NumPy or CuPy namespace,
with the exception that functions having counterparts in the Array API Standard
are wrapped to ensure specification-compliant behavior.

Currently, the compatibility layer supports NumPy, CuPy, and PyTorch, but we're
hoping to extend support to additional array libraries in the year ahead. In
the meantime, if you're an array library consumer, we'd love to get your
feedback. To get started, install from
[PyPI](https://pypi.org/project/array-api-compat/)

```bash
pip install array-api-compat
```

and take it for a spin! If you encounter any issues, please be sure to let us
know over on the library issue
[tracker](https://github.com/data-apis/array-api-compat/issues).

## The Road Ahead

So what's in store for 2023?! The primary theme for 2023 is adoption, adoption,
and more adoption. We're deeply committed to ensuring the success of this
Consortium and to improving the landscape of array computing within the PyData
ecosystem. While achieving buy-in from array libraries across the ecosystem has
been a significant achievement, what is critical for the long-term success of
this collective effort is driving adoption among downstream libraries, such as
SciPy, scikit-learn, and others, in order to achieve our stated goal of
facilitating interoperability among array libraries. In short, we want to
unshackle downstream libraries from any one particular array library and
provide users of SciPy et al the freedom to use, not just NumPy, but the array
library which best makes sense for them and their use cases.

To drive this effort, we'll be

1. working closely with downstream libraries to identify existing pain points
   and blockers preventing adoption.
2. developing a robust set of tools for specification compliance monitoring and
   reporting.
3. extending the [array compatibility
   layer](https://github.com/data-apis/array-api-compat) to support additional
   array libraries and thus further smooth the transition to a shackle-free
   future.

We're excited for the year ahead, and we'd love to get your feedback! To
provide feedback on the Array API Standard, please open issues or pull requests
on <https://github.com/data-apis/array-api>.

Cheers!
