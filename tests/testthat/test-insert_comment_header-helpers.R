test_that("is_try_success() works", {
    tmp_fn <- function() 3 * 5

    expect_true(is_try_success(tmp_fn()))
    expect_false(is_try_success(not_defined_fn()))
})

test_that("parse_input() works", {
    expect_equal(parse_input("hello", 8), "h...")
    expect_equal(parse_input("", 8), "")
    expect_equal(parse_input("hello", 10), "hello")
})

test_that("many() works", {
    expect_equal(many("a", 3), "aaa")
    expect_equal(many("aa", 3), "aaaaaa")
    expect_equal(many("b", 10), "bbbbbbbbbb")
    expect_equal(many("aa", 3, "!"), "!aaaaaa!")
})

test_that("left_fn() works", {
    w    <- 10
    fn_a <- left_fn(w)
    w    <- 20
    fn_b <- left_fn(w)

    expect_equal(fn_a("hello"), "# hello  #")
    expect_equal(fn_b("hello"), "# hello            #")
    expect_equal(fn_a("hello world"), "# hel... #")
})

test_that("right_fn() works", {
    w    <- 10
    fn_a <- right_fn(w)
    w    <- 20
    fn_b <- right_fn(w)

    expect_equal(fn_a("hello"), "#  hello #")
    expect_equal(fn_b("hello"), "#            hello #")
    expect_equal(fn_a("hello world"), "# hel... #")
})

test_that("center_fn() works", {
    w    <- 14
    fn_a <- center_fn(w)
    w    <- 21
    fn_b <- center_fn(w)

    expect_equal(fn_a("hello"), "#   hello    #")
    expect_equal(fn_b("hello"), "#       hello       #")
    expect_equal(fn_a("hello world"), "# hello w... #")
})

test_that("space_if_present() works", {
    a <- NULL
    b <- NULL
    c <- "not null"
    d <- "also not null"

    expect_null(spacer_if_present(a))
    expect_null(spacer_if_present(a, b))
    expect_equal(spacer_if_present(c), " ")
    expect_equal(spacer_if_present(c, d), " ")
    expect_equal(spacer_if_present(c, a), " ")
    expect_equal(spacer_if_present(a, c, b), " ")
    expect_equal(spacer_if_present(a, b, c, d), " ")
})

test_that("enframe_text() works", {
    expect_snapshot(cat(enframe_text("hello", "how", "are", "you")))
    expect_snapshot(cat(enframe_text("hello", NULL, "you")))
    expect_null(enframe_text(NULL))
})

test_that("merge_text() works", {
    expect_equal(merge_text("hello"), "hello")
    expect_equal(merge_text("hello", "world"), "hello\nworld")
    expect_equal(merge_text("hello", NULL, "world"), "hello\nworld")
    expect_equal(merge_text("hello", "world", "foo"), "hello\nworld\nfoo")
    expect_equal(merge_text(NULL, "hello", "world", NULL), "hello\nworld")
    expect_type(merge_text(NULL), "character")
    expect_length(merge_text(NULL), 0)
})

test_that("small_header_constructor() works", {
    # default behavior should ignore additional arguments in ...
    header <- small_header_constructor("hello", "world", "foo", "bar", "ok")
    contained <- vapply(c("hello", "world", "foo", "bar", "ok"), \(x) grepl(x, header), logical(1))

    expect_true(all(contained[1:3]))
    expect_true(all(!contained[4:5]))
    expect_equal(nchar(header), 307)
    expect_equal(substr(header, 1, 51), paste0(paste(rep("#", 50), collapse = ""), "\n"))
    expect_equal(substr(header, 255, 307), paste0("\n", paste(rep("#", 50), collapse = ""), "\n\n"))

    # additional arguments should be included if include_additional==TRUE
    header <- small_header_constructor("hello", "world", "foo", "bar", "ok",
                                       include_additional = TRUE)

    contained <- vapply(c("hello", "world", "foo", "bar", "ok"), \(x) grepl(x, header), logical(1))
    expect_true(all(contained))
    expect_equal(nchar(header), 460)
    expect_equal(substr(header, 1, 51), paste0(paste(rep("#", 50), collapse = ""), "\n"))
    expect_equal(substr(header, 408, 460), paste0("\n", paste(rep("#", 50), collapse = ""), "\n\n"))
})