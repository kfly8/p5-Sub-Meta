        like dies { $meta->apply_attribute('foo') }, qr/Invalid CODE attribute: foo/, 'invalid attribute';

        like dies { Sub::Meta->new->apply_subname('hello') }, qr/apply_subname requires subroutine reference/, 'apply_subname requires subroutine reference';

        like dies { Sub::Meta->new->apply_prototype('$$') }, qr/apply_prototype requires subroutine reference/, 'apply_prototype requires subroutine reference';

        like dies { Sub::Meta->new->apply_attribute('lvalue') }, qr/apply_attribute requires subroutine reference/, 'apply_attribute requires subroutine reference';

