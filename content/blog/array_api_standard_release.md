+++
date = "2020-11-10T08:00:00+00:00"
author = "Ralf Gommers"
title = "First release of the Array API Standard"
tags = ["APIs", "standard", "consortium", "arrays", "community"]
categories = ["Consortium", "Standardization"]
description = "This first release of the standards document and accompanying test suite marks the start of the community review period."
draft = false
weight = 30
+++

Array and tensor libraries - from NumPy, TensorFlow and PyTorch to Dask, JAX,
MXNet and beyond - could benefit greatly from a uniform API for creating and
working with multi-dimensional arrays (a.k.a tensors), as we discussed in
[our previous blog post]({{< relref "announcing_the_consortium.md" >}}).
Today we're pleased to announce a first version of our array API standard
([document](https://data-apis.github.io/array-api/latest),
[repo](https://github.com/data-apis/array-api/)) for review by the
wider community. Getting to this point took slightly longer than we had
initially announced because, well, it's 2020 and hence nothing quite goes
according to plan.

The current status of the standard is that it is a coherent story (or at
least, we hope it is) that gives readers enough context about goals and scope
to understand and review the design decisions already taken and APIs it
contains. However, _it is not yet complete and we can still change direction
and make significant changes based on community feedback_. This is important
--- no one likes a "take it or leave it" approach, and more eyes can make the
final result better. There's still a few TODOs in places, and a couple of key
sections to be finished. The most important of those are the API for device
support, and the Python API for the
[data interchange protocol](https://data-apis.github.io/array-api/latest/design_topics/data_interchange.html)
(proposed to be based on [DLPack](https://github.com/dmlc/dlpack)).

It is worth repeating the main goal of this standard: make it easier to
switch from one array library to another one, or to support multiple array
libraries as compute backends in downstream packages. We'd also like to
emphasize that if some functionality is _not_ present in the API standard,
that does _not_ mean it's unimportant, or that we're asking existing array
libraries to deprecate it. Instead it simply means that that functionality at
present isn't supported - likely due to it not being present in all or most
current array libraries, or not being used widely enough to have been
included so far. The [use cases section](https://data-apis.github.io/array-api/latest/use_cases.html)
of the standard may provide more insight into important goals.


## Some key design topics

Two topics stood out so far in terms of complexity and choices that were hard
to make in such a way that they'd work well for all existing libraries:
mutability & copy/view behaviour, and dtype casting rules.

##### The standard will contain common mutable operations such as slice assignment, but will generally avoid in-place mutation in APIs like the `out` keyword

NumPy, PyTorch, CuPy and MXNet provide strided arrays, and rely heavily on
mutating values in existing arrays and on the concept of a "view" for
performance. TensorFlow, JAX and Dask on the other hand have no or limited
support, given that they rely on an execution graph and/or JIT compiler which
provides constraints on how much mutability can be supported. The design
decisions described [here](https://data-apis.github.io/array-api/latest/design_topics/copies_views_and_mutation.html)
will allow the most heavily used types of mutability - inplace operators,
item assignment and slice assignment - to be retained, while avoiding the use
of the `out=` keyword which is problematic to support for some libraries and
arguably a suboptimal API to begin with.

For libraries like SciPy and scikit-learn, the supported features are essential.
Code like this, from scikit-learn's `ForestClassifier`:

```python
for k in range(self.n_outputs_):
    predictions[k][unsampled_indices, :] += p_estimator[k]
```

or this, from SciPy's `optimize.linprog`:

```python
r = b - A@x
A[r < 0] = -A[r < 0]
b[r < 0] = -b[r < 0]
r[r < 0] *= -1
```

is quite common and we see it as fundamental to how users work with array libraries.
`out=` is less essential though, and leaving it out is important for JAX,
TensorFlow, Dask, and future libraries designed on immutable data structures.


##### Casting rules for mixed type families will not be specified and are implementation specific

Casting rules are relatively straightforward when all involved dtypes are of
the same kind (e.g. all integer), but when mixing for example integers and
floats it quickly becomes clear that array libraries don't agree with each
other. One may get exceptions, or dtypes with different precision. Therefore
we had to make the choice to leave the rules for "mixed kind dtype casting"
undefined - when users want to write portable code, they should avoid this
situation or use explicit casts to obtain the same results from different
array libraries. An example as simple as this one:

```python
x = np.arange(5)  # will be integer
y = np.ones(5, dtype=float16)
(x * y).dtype
```

will show the issue. NumPy will produce `float64` here, PyTorch will produce
`float16`, and TensorFlow will raise `InvalidArgumentError` because it does not
support mixing integer and float dtypes.

See [this section of the standard](https://data-apis.github.io/array-api/latest/API_specification/type_promotion.html)
for more details on casting rules.


## A portable test suite

With the array API standard document we are also working on a
[test suite](https://github.com/data-apis/array-api-tests). This test suite
will be implemented with Pytest and Hypothesis, and won't rely on any
particular array implementation, and is meant to test compliance with the API
standard.

It is still very much a work-in-progress, but the aim is to complete it by
the time the community review of the API standard wraps up. However, the
community is encouraged to check out the current work on the test suite on
[GitHub](https://github.com/data-apis/array-api-tests) and try it out and
comment on it. The
[README](https://github.com/data-apis/array-api-tests/blob/master/README.md)
in the test suite repo contains more information on how to run it and
contribute to it.

The test suite will be runnable with any existing library. This can be done
by specifying the array implementation namespace to be tested via an
environment variable:

```bash
$ ARRAY_API_TESTS_MODULE=jax.numpy pytest
```

The test suite will also support vendoring so that array libraries can easily
include it in their own test suites.

The result of running the test suite will be an overview of the level of
compliance with the standard. We expect it will take time for libraries to
get to 100%; anything less shouldn't just mean "fail", 98% would be a major
step towards portable code compared to today.


## People & projects

So who was involved in getting the API standard to this point, and which
libraries do we hope will adopt this standard? The answer to the latter is
"all existing and new array and tensor libraries with a Python API". As for
who was involved, we were lucky to get contributions from creators and senior
maintainers of almost every of interest - here's a brief description:

- NumPy: Stephan Hoyer and Ralf Gommers are both long-time NumPy maintainers.
  In addition we got to consult regularly with Travis Oliphant, creator of
  NumPy, on the history behind some decisions made early on in NumPy's life.
- TensorFlow: Alexandre Passos was a technical lead on the TensorFlow team,
  and has been heavily involved until a few weeks ago. Paige Bailey is the
  product manager for TensorFlow APIs at Google Research. Edward Loper and
  Ashish Agarwal, TensorFlow maintainers, replaced Alexandre recently as
  Consortium members.
- PyTorch: Adam Paszke is one of the co-creators of PyTorch. Ralf Gommers
  leads a team of engineers contributing to PyTorch.
- MXNet: Sheng Zha is a long-time MXNet maintainer. Markus Weimer is an
  Apache PMC member and mentor for the MXNet incubation process into the
  Apache Foundation.
- JAX: Stephan Hoyer and Adam Paszke are two maintainers of JAX.
- XArray: Stephan Hoyer is one of the co-creators, and still a maintainer, of Xarray.
- Dask: Tom Augspurger is a senior Dask maintainer.
- CuPy: we have no active participant from CuPy. However we have talked to
  the CuPy team at Preferred Networks, who are supportive of the goals and
  committed to following NumPy's lead on APIs.
- ONNX: Sheng Zha is an ONNX Steering Committee member.

Many other people have made contributions so far, including the Consortium
members listed at https://github.com/data-apis/governance.


## Next steps to a first complete standard

We are now looking for feedback from the wider community, and in particular
maintainers of array libraries. For each of those libraries, a Consortium
member involved in the library will be soliciting feedback from their own
project. We'd like to get to the point where it's clear for each library that
there are no blockers to adoption and that the overall shape of the API
standard is considered valuable enough to support.

In addition, given that this API standard is completely new and drafting
something like it hasn't been attempted before in this community, we'd love
to get meta feedback - is anything missing or in need of shaping in the
standard document, the goal and scope, ways to participate, or any other such
topic?

To provide feedback on the array API standard, please open issues or pull
requests on https://github.com/data-apis/array-api. For larger discussions
and meta-feedback, please open GitHub Discussion topics at
https://github.com/data-apis/consortium-feedback/discussions.
