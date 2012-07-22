//
//  Shader.fsh
//  GLCoverPage
//
//  Created by Jonathan Blocksom on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
