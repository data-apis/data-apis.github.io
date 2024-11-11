+++
date = "2024-11-11T08:00:00+00:00"
author = "Athan Reines"
title = "CZI EOSS 6 Award to Advance Array Interoperability within the PyData Ecosystem"
tags = ["APIs", "standard", "consortium", "arrays", "community", "funding", "czi", "eoss6"]
categories = ["Consortium", "Standardization"]
description = "The Chan Zuckerberg Initiative (CZI) awarded an EOSS Cycle 6 grant to the Data APIs Consortium to advance array interoperability within the PyData ecosystem."
draft = false
weight = 30
+++

We are thrilled to announce that the Chan Zuckerberg Initiative (CZI) recently
awarded the Consortium for Python Data API Standards an Essential Open Source
Software for Science(EOSS) Cycle 6 grant to support ongoing work within the
Consortium and to accelerate the adoption of the Array API Standard across the
PyData ecosystem. With this award, we'll drive forward our vision of
standardizing a universal API for array operations, enhancing library
interoperability, and increasing accessibility to high-performance
computational resources across scientific domains.

## The Importance of the EOSS Program

The EOSS program by CZI was launched to support open source software that is
foundational for scientific research, especially within biology and medicine.
As software tools underpin modern scientific investigation, ensuring these
tools receive adequate funding is crucial for sustainable growth and long-term
impact. Through EOSS, CZI has committed to funding development, usability
improvements, community engagement, and maintenance efforts for critical open
source tools. This support enables open source software to be more accessible,
reliable, and adaptable to researchers' evolving needs.

With the EOSS Cycle 6 award, Quansight, in cooperation with collaborators within
the Consortium and the broader ecosystem, will focus on advancing
interoperability, improving ease of Array API adoption, and reducing array
library fragmentation within the PyData ecosystem.

## Addressing Fragmentation in the PyData Ecosystem

As Python's popularity has grown, so has the number of frameworks and libraries
for numerical computing, data science, and machine learning. Researchers and
data science practitioners now have access to a vast suite of tools and
libraries for computation, but this diversity comes with the challenge of
fragmented APIs for fundamental data structures such as multidimensional
arrays. While array libraries largely follow similar paradigms, their API
differences present a real challenge for users who need to switch between or
integrate multiple libraries in their workflows.

The Consortium for Python Data API Standards, founded in 2020, addresses this
issue directly. By standardizing a universal array API, the Consortium seeks to
simplify the process for users moving between libraries and foster an ecosystem
where array operations are seamless across libraries such as NumPy, CuPy,
PyTorch, and JAX. To date, the Array API Standard has seen adoption by major
libraries, laying the groundwork for an interoperable PyData ecosystem that
emphasizes compatibility and ease of use.

If you're curious to learn more about the Consortium, its origins, and the
benefits of standardization, be sure to read our 2023 SciPy Proceedings paper
["Python Array API Standard: Toward Array Interoperability in the Scientific
Python Ecosystem"](https://proceedings.scipy.org/articles/gerudo-f2bc6f59-001).

## Scope of Work for the EOSS 6 Award

The EOSS 6 award will help the Consortium focus on key initiatives to expand
adoption and improve compatibility across the ecosystem. The proposed work
includes:

### Array API Adoption in Downstream Libraries

One of our primary goals is to further adoption of the Array API Standard in
downstream libraries, such as SciPy, scikit-learn, and scikit-image.
Historically, many downstream libraries have been dependent on NumPy, thus
limiting their execution model to CPU-bound computation and thus their ability
to leverage the performance advantages of GPU- or TPU-based computation. By
adopting the Standard, downstream libraries will be able to support array
libraries such as CuPy and PyTorch, empowering researchers to take advantage of
the hardware acceleration options suitable to their needs.

### Infrastructure for Adoption and Compliance Tracking

We're also committed to building infrastructure to monitor compliance and
adoption of the Array API across the ecosystem. While we have already developed
a [test suite](https://github.com/data-apis/array-api-tests) to measure
compliance for array libraries, this tool has been largely developer-facing,
leaving end users with limited visibility into compatibility across different
libraries. To address this gap, we will create public mechanisms, such as
compatibility tables, for tracking which libraries are adopting the Standard
and helping users make informed decisions about which libraries to use.

Additionally, we plan to develop mechanisms for automating compliance tracking
within array library continuous integration (CI) workflows, allowing real-time
monitoring of adoption and compatibility regressions. This infrastructure will
hopefully instill greater confidence among end users in array library
compatibility and help array library developers maintain interoperability.

### Comprehensive Documentation and Migration Guides

As adoption grows, we recognize the need for high-quality documentation and
migration guides to help users and developers transition seamlessly to using
the Array API Standard. Through our collaborations with library maintainers,
we've gathered insights into best practices for building array library-agnostic
applications. With EOSS 6 funding, we'll transform these insights into
tutorials, case studies, and migration guides to facilitate adoption among
downstream libraries. By offering clear and accessible resources, we aim to
reduce the learning curve for new users and provide developers with the tools
they need to confidently build array library-agnostic applications.

## Value to the Scientific Community and End Users

The work funded by this award will provide significant benefits to users within
the scientific research community. Our hope is that this work will yield three
primary outcomes:

1. **Interoperability Across Libraries**: Fragmentation within the ecosystem has
often led to duplication of effort, limited access to hardware acceleration,
and the need for repeated re-implementation of foundational array structures.
By fostering interoperability across libraries, we aim to simplify the process
of moving between technical stacks and unlock new performance gains for array
library consumers.

2. **Standardization and Reduced Switching Costs**: Users will benefit from
shorter learning curves and lower costs associated with switching libraries.
With standardized APIs and robust compliance infrastructure, users will have
greater confidence that their workflows will be portable across array
libraries, regardless of the underlying computational backend.

3. **Enhanced Performance for Array-Consuming Libraries**: Array API adoption
has [already shown](https://proceedings.scipy.org/articles/gerudo-f2bc6f59-001)
promising performance improvements across several libraries in the ecosystem.
For example, performance gains of up to 50x in SciPy and 10-40x in scikit-learn
were observed upon integrating support for alternative array libraries such as
CuPy and PyTorch. We hope to observe similar acceleration in other downstream
libraries, which could dramatically reduce analysis time for computationally
intensive research tasks, ultimately improving efficiency and access for users
working with high-dimensional data.

## Looking Forward

As we embark on this phase of our work, we're excited to continue pushing
forward the Array API Standard as a unifying foundation for the PyData
ecosystem. Support from CZI's EOSS program is instrumental in making this
vision a reality, and we're committed to expanding the impact of the Array API
Standard through real-world applications and community engagement.

With this award, we're not only addressing technical fragmentation but also
advancing a more inclusive, accessible, and robust future for scientific
computing. We look forward to collaborating with the community to make array
interoperability a reality across the ecosystem and to empower researchers with
tools that help them achieve scientific breakthroughs more efficiently and
effectively.

Stay tuned for updates as we implement these initiatives and continue to
strengthen the foundations of the PyData ecosystem!

---

## Funding Acknowledgment

This project has been made possible in part by grant number EOSS6-0000000621
from the Chan Zuckerberg Initiative DAF, an advised fund of Silicon Valley
Community Foundation. Athan Reines is the grant's principal investigator and
Quansight Labs is the entity receiving and executing on the grant.