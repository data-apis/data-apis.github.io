+++
date = "2024-04-08T08:00:00+00:00"
author = "Athan Reines"
title = "2023 release of the Array API Standard"
tags = ["APIs", "standard", "consortium", "arrays", "community"]
categories = ["Consortium", "Standardization"]
description = "The 2023 revision of the array API standard has been finalized and is ready for adoption by conforming array libraries."
draft = false
weight = 30
+++

Another year, another revision of the Array API Standard! We're proud to announce the release of the 2023 revision of the Array API Standard. As was the case for [2022 revision](https://data-apis.org/blog/array_api_v2022_release/), this release required extensive discussion and collaboration among array libraries and their downstream stakeholders as we continued reaching consensus on unified API design and behavior. We're particularly excited to share that this year marked a significant milestone in our efforts to facilitate array interoperation within the PyData ecosystem, as we witnessed accelerated adoption of the standard, especially among downstream libraries, such as [SciPy[(https://docs.scipy.org/doc/scipy//dev/api-dev/array_api.html)] and [scikit-learn](https://scikit-learn.org/stable/modules/array_api.html).

## Brief Background

For those who are not yet familiar with the Consortium and the Array API Standard, a bit of background. Our aim is to standardize the fundamental building blocks of scientific computation: multi-dimensional arrays (a.k.a. tensors). The PyData ecosystem has a rich set of libraries for working with arrays, including NumPy, CuPy, Dask, PyTorch, JAX, TensorFlow, oneAPI, and beyond. Historically, interoperation among array libraries has been challenging due to divergent API designs and subtle variation in behavior such that code written for one array library cannot be readily ported to another array library. To address these challenges, the [Consortium for Python Data API Standards](https://data-apis.org/blog/announcing_the_consortium/) was established to facilitate coordination among array and dataframe library maintainers, sponsoring organizations, and key stakeholders and to provide a transparent and inclusive process--with input from the broader Python community--for standardizing array API design.

Soon after formation of the Consortium in May 2020, we released an [initial draft](https://data-apis.org/blog/array_api_standard_release/) of the array API specification and sought input from the broader PyData ecosystem during an extended community review period. Throughout 2021, we engaged in a tight feedback loop with array API adopters to refine and improve the initial draft specification.

During this time, we reached three key milestones. First, we introduced a data interchange protocol based on [DLPack](https://github.com/dmlc/dlpack) to facilitate zero-copy memory exchange between array libraries. Second, we standardized a core set of API designs for array creation, mutation, and element-wise computation. Third, we introduced "extensions", which are defined as coherent sets of functionality that are commonly implemented across array libraries, but which conforming array libraries may choose not to implement. The first extension we included in the specification was the `linalg` extension, which defines a set of linear algebra APIs for computing eigenvalues, performing singular value decomposition, solving a system of linear equations, and other linear algebra operations.

Building on the success of the 2021 revision of the Array API Standard, we worked throughout 2022 on a subsequent specification revision with two key objectives: standardize complex number support and standardize an extension for Fast Fourier Transforms (FFTs). These efforts culminated in the [2022 revision](https://data-apis.org/blog/array_api_v2022_release/) of the Array API Standard, along with significant advancements in tooling to support specification adoption. Importantly, we released 1) a comprehensive portable [test suite](https://github.com/data-apis/array-api-tests) built on Pytest and Hypothesis for testing Array API Standard compliance and 2) an [array compatibility layer](https://github.com/data-apis/array-api-compat) which provides a small wrapper around existing array libraries to ensure Array API Standard compliant behavior.

With the 2022 revision out of the way, we summarized our work to date, publishing in _SciPy Proceedings_ the paper ["Python Array API Standard: Toward Array Interoperability in the Scientific Python Ecosystem"](https://proceedings.scipy.org/articles/018d8c34-e9ca-7105-9366-a050cc18b214). Needless to say, it was a busy three years!

## 2023 Revision

Not wanting to rest on our laurels, immediately after tagging the 2022 release we got busy working on the [2023 revision](https://github.com/data-apis/array-api/blob/91ff864decaef09a7fcca28a4b65de3c5f765d5f/CHANGELOG.md#v202312) with a singular goal: eliminate any and all barriers to adoption. While achieving buy-in from array libraries across the ecosystem marked a significant achievement, what is critical for the long-term success of this collective effort is driving adoption among downstream libraries, such as SciPy, scikit-learn, and others, in order to achieve our stated goal of facilitating interoperability among array libraries.

To this end, we solicited feedback from downstream adopters regarding missing APIs, pain points, and general blind spots. During our discussions, we made three key observations. First, for a small subset of APIs, the behavior required by the standard did not match the reality on the ground, and we needed to revise the standard in order to ensure array libraries and their consumers could both achieve compliance **and** maintain backward compatibility. Second, we noticed a common set of operations which downstream adopters kept needing and for which they were implementing inefficient workarounds, thus making these operations excellent candidates for standardization. And lastly, we found that downstream adopters needed robust and portable mechanisms for inspecting library and device capabilities.

### Breaking Changes

To address our first observation, we made two breaking changes to the 2022 revision of the standard. First, we revised the guidance for type promotion in `prod`, `sum`, and `linalg.trace` such that, by default, input arrays having floating-point data types are not upcasted to higher precision. The previous guidance reflected the concern that summation of large arrays having low precision could easily lead to overflow. While this concern is certainly valid for arrays having integer data types (e.g., `int8` and `int16`), this is less of a concern for floating-point data types which can typically handle a larger range of values and have a natural overflow value in infinity.

Second, we revised the guidance for portable input and output data types in FFT APIs. One of the specification's overriding design principles is requiring users to be explicit about their intent. In the 2022 revision, we failed to fully adhere to this principle in the FFT APIs, leading to ambiguity of acceptable return types and the potential for undesired automatic upcasting of real-valued arrays to complex-valued arrays. We thus sought to correct this deficiency and subsequently backported the changes to the 2022 revision.

### New Additions

To address our second observation, we identified and standardized several new APIs to ensure portable behavior among conforming array libraries.

-   `clip`: clamps each element of an array to a specified range.
-   `copysign`: composes a floating-point value from a magnitude and sign.
-   `cumulative_sum`: calculates the cumulative sum.
-   `hypot`: computes the square root of the sum of squares.
-   `maximum`: computes the maximum value for each element of an array relative to the respective element in another array.
-   `minimum`: computes the minimum value for each element of an array relative to the respective element in another array.
-   `moveaxis`: moves array axes to new positions.
-   `repeat`: repeats each element of an array a specified number of times.
-   `searchsorted`: finds insertion positions such that sorted order would be preserved.
-   `signbit`: determines whether the sign bit is set for each element in an array.
-   `tile`: constructs an array by tiling another array.
-   `unstack`: splits an array into a sequence of arrays along a given axis.

### Inspection APIs

To address our third observation, we recognized that downstream library adopters needed more robust mechanisms for determining library and associated device capabilities. For libraries such as SciPy and scikit-learn who want to support array objects from multiple libraries, having a set of standardized top-level APIs is not sufficient. In order to devise concise mitigation strategies and gracefully handle varying hardware capabilities, having a means for reliably ascertaining device heterogeneity is critical. Accordingly, we worked to standardize inspection APIs to allow answering the following questions:

-   does a library support boolean indexing and data-dependent output shapes?
-   how can one portably obtain a library's list of supported devices?
-   what is a library's default device?
-   what data types does a library support?
-   what are a library's default data types?
-   what data types does a specific device support?

After considerable discussion and coordination among array libraries and downstream stakeholders, we coalesced around an inspection API namespace

```python
info = xp.__array_namespace_info__()
```

with the following initial set of APIs:

-   `capabilities`: returns a dictionary of array library capabilities.
-   `default_device`: returns the default device.
-   `default_types`: returns a dictionary containing default data types.
-   `dtypes`: returns a dictionary containing supported data types specific to a given device.
-   `devices`: returns a list of supported devices.

While these APIs may seem trivial on their surface, the reality is that array libraries have often lacked easy and portable programmatic access to data type and device information. We thus consider this outcome significant progress, and we're particularly eager to hear from downstream library authors what other capabilities they would find useful to query.

## Facilitating Array API Adoption

As mentioned above, 2023 was all about adoption, and adoption requires buy-in from both array libraries and the downstream consumers of those libraries. Adoption thus faces two key challenges. First, to facilitate development, array libraries need a robust mechanism for determining whether they are specification compliant. Second, while array libraries work to become fully specification compliant, downstream libraries need to be able to target a stable compatibility layer in order to smooth over subtle differences in array library behavior.

### Test Suite

To address the first challenge, we've continued to develop a comprehensive portable [test suite](https://github.com/data-apis/array-api-tests) built on Pytest and Hypothesis for testing Array API Standard compliance. In addition to the 2022 revision, the test suite has been updated to support the most recent 2023 revision.

### Compatibility Layer

To address the second challenge, we've continued work on an [array compatibility layer](https://github.com/data-apis/array-api-compat) which provides a small wrapper around existing array libraries to ensure Array API Standard compliant behavior. We're proud to announce that, in addition to support for NumPy, CuPy, and PyTorch, we've added support for [Dask](https://github.com/data-apis/array-api-compat/pull/76) and [JAX](https://github.com/data-apis/array-api-compat/pull/84).

To get started, install from [PyPI](https://pypi.org/project/array-api-compat/)

```bash
pip install array-api-compat
```

and take it for a spin! If you encounter any issues, please be sure to let us know over on the library issue [tracker](https://github.com/data-apis/array-api-compat/issues).

## Adoption Milestones

Array libraries, such as NumPy, CuPy, PyTorch, JAX, and oneAPI, have continued work toward achieving full API compliance, which is a significant milestone in and of itself. But it's all for naught if array library consumers are not able to reap the benefits of standardization. Needless to say, we've seen significant uptake of the Array API Standard among downstream libraries. In particular, both [SciPy](https://docs.scipy.org/doc/scipy//dev/api-dev/array_api.html) and [sckit-learn](https://scikit-learn.org/stable/modules/array_api.html) have added experimental support, thus enabling support for both CPU and GPU tensors and marking a big win for end users. For the curious reader, we discussed some of the performance benefits in our recent [paper](https://proceedings.scipy.org/articles/018d8c34-e9ca-7105-9366-a050cc18b214) published in _SciPy Proceedings_ (2023).

### NumPy

One development that is especially noteworthy is the adoption of the Array API Standard in the main namespace of [NumPy 2.0](https://numpy.org/devdocs/release/2.0.0-notes.html). When we originally formed the Consortium and began the work of standardization, we didn't know exactly how array libraries would prefer to adopt an eventual array API standard. Would they adopt it in their main namespace? Or would they prefer to avoid potentially breaking backward compatibility and implement in a strictly compliant sub-namespace?

We wrote the specification with both possibilities in mind. NumPy and its kin went down the sub-namespace path, while libraries such as PyTorch opted for their main namespace. Well, after a few years of experimentation, the NumPy community decided that they liked the standard so much that relegating a strictly compliant implementation to a sub-namespace was not enough, and subsequently sought to apply the API design principles not just to standardized APIs in their main namespace, but across all of NumPy. This is a significant win for portability, and we're excited for the benefits NumPy 2.0 will bring to downstream libraries and the PyData ecosystem at large.

## The Road Ahead

Phew! That's a lot, and you've made it this far! So what's in store for 2024?! Glad you asked. Nothing too different from the year before. We're planning on staying the course, focusing on adoption, and continuing to address the gaps and pain points identified by downstream libraries.

In addition to normal specification work, we're particularly keen on developing more robust tools for specification compliance and monitoring. Based on feedback we've received from downstream libraries, there's still a lack of transparency around which APIs are supported and what are the potential edge cases. We have some ideas for how to increase visibility and will have more to share in the months to come.

Long story short, we're excited for the year ahead, and we'd love to get your feedback! To provide feedback on the Array API Standard, please open issues or pull requests on <https://github.com/data-apis/array-api>, and come participate in our public [discussions](https://github.com/data-apis/array-api/discussions).

Cheers!
