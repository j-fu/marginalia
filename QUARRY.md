## Project structure patterns

We assume that a project consists of two parts:
- frontend code:
  - calculations for obtaining project results
  - calculations for presenting project results
  - 


Julia language syntax provides two ways to access code in other files:
the  `include` function  and  the `using`  resp.  `import`  statement.

There are some drawbacks of `include`:

- `include` is depending on file locations
- code structuring via modules is not enforces with `include`
- When working together  with Revise, `include` needs to  be replaced by `includet` for enabling tracking, while code accessed via `using` will be automatically tracked.


