import React from 'react'
import Svg, { Path } from 'react-native-svg'

export const CampusIcon = props => {
    let color = props.color ? props.color : "#FFF";
    return (
        <Svg
            aria-hidden="true"
            data-prefix="fas"
            data-icon="map"
            className="prefix__svg-inline--fa prefix__fa-map prefix__fa-w-18"
            viewBox="0 0 576 512"
            {...props}
        >
            <Path
                className="prefix__st0"
                d="M0 117.66v346.32c0 11.32 11.43 19.06 21.94 14.86L160 416V32L20.12 87.95A32.006 32.006 0 0 0 0 117.66zM192 416l192 64V96L192 32v384zM554.06 33.16L416 96v384l139.88-55.95A31.996 31.996 0 0 0 576 394.34V48.02c0-11.32-11.43-19.06-21.94-14.86z"
                fill={color}
            />
        </Svg>
    )
}
