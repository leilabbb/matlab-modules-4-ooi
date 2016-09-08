function F_delete_empty_files(filea,file1,file2,file3,file4)

    ofa = dir(filea);
    if ofa.bytes == 0
        delete(filea)
        disp([ofa,' empty'])
    end

    of1 = dir(file1);
    if of1.bytes == 0
        delete(file1)
        disp([of1,' empty'])
    end

    of2 = dir(file2);
    if of2.bytes == 0
        delete(file2)
        disp([of2,' empty'])
    end

    of3 = dir(file3);
    if of3.bytes == 0
        delete(file3)
        disp([of3,' empty'])
    end 

    of4 = dir(file4);
    if of4.bytes == 0
        delete(file4)
        disp([of4,' empty'])
    end

end


